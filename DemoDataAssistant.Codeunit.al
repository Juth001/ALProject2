codeunit 50100 "Demo Data Management"
{
    var
        RandomHelper: Codeunit "Random Helper";

    // ==================== DATOS MAESTROS ====================

    procedure GenerateCustomers(HowMany: Integer)
    var
        Customer: Record Customer;
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            Clear(Customer);
            Customer.Init();
            Customer.Validate("No.", GetNextCustomerNo());
            Customer.Validate(Name, RandomHelper.GetRandomCompanyName());
            Customer.Validate(Address, RandomHelper.GetRandomAddress());
            Customer.Validate(City, RandomHelper.GetRandomCity());
            Customer.Validate("Post Code", RandomHelper.GetRandomPostCode());
            Customer.Validate("Country/Region Code", RandomHelper.GetRandomCountryCode());
            Customer.Validate("Phone No.", RandomHelper.GetRandomPhoneNumber());
            Customer.Validate("E-Mail", RandomHelper.GetRandomEmail(Customer.Name));
            Customer.Validate("Gen. Bus. Posting Group", GetDefaultGenBusPostingGroup());
            Customer.Validate("VAT Bus. Posting Group", GetDefaultVATBusPostingGroup());
            Customer.Validate("Customer Posting Group", GetDefaultCustomerPostingGroup());
            Customer.Validate("Payment Terms Code", GetDefaultPaymentTerms());
            Customer.Validate("Payment Method Code", GetDefaultPaymentMethod());
            Customer.Insert(true);
        end;
    end;

    procedure GenerateVendors(HowMany: Integer)
    var
        Vendor: Record Vendor;
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            Clear(Vendor);
            Vendor.Init();
            Vendor.Validate("No.", GetNextVendorNo());
            Vendor.Validate(Name, RandomHelper.GetRandomCompanyName());
            Vendor.Validate(Address, RandomHelper.GetRandomAddress());
            Vendor.Validate(City, RandomHelper.GetRandomCity());
            Vendor.Validate("Post Code", RandomHelper.GetRandomPostCode());
            Vendor.Validate("Country/Region Code", RandomHelper.GetRandomCountryCode());
            Vendor.Validate("Phone No.", RandomHelper.GetRandomPhoneNumber());
            Vendor.Validate("E-Mail", RandomHelper.GetRandomEmail(Vendor.Name));
            Vendor.Validate("Gen. Bus. Posting Group", GetDefaultGenBusPostingGroup());
            Vendor.Validate("VAT Bus. Posting Group", GetDefaultVATBusPostingGroup());
            Vendor.Validate("Vendor Posting Group", GetDefaultVendorPostingGroup());
            Vendor.Validate("Payment Terms Code", GetDefaultPaymentTerms());
            Vendor.Validate("Payment Method Code", GetDefaultPaymentMethod());
            Vendor.Insert(true);
        end;
    end;

    procedure GenerateItems(HowMany: Integer)
    var
        Item: Record Item;
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            Clear(Item);
            Item.Init();
            Item.Validate("No.", GetNextItemNo());
            Item.Validate(Description, RandomHelper.GetRandomItemDescription());
            Item.Validate(Type, Item.Type::Inventory);
            Item.Validate("Base Unit of Measure", GetDefaultUnitOfMeasure());
            Item.Validate("Gen. Prod. Posting Group", GetDefaultGenProdPostingGroup());
            Item.Validate("VAT Prod. Posting Group", GetDefaultVATProdPostingGroup());
            Item.Validate("Inventory Posting Group", GetDefaultInventoryPostingGroup());
            Item.Validate("Unit Price", RandomHelper.GetRandomDecimal(10, 1000));
            Item.Validate("Unit Cost", RandomHelper.GetRandomDecimal(5, 500));
            Item.Validate("Costing Method", Item."Costing Method"::FIFO);
            Item.Insert(true);

            // Crear inventario inicial
            CreateInitialInventory(Item."No.", RandomHelper.GetRandomInteger(10, 500));
        end;
    end;

    // ==================== TRANSACCIONES DE VENTA ====================

    procedure GenerateSalesOrders(HowMany: Integer)
    var
        SalesHeader: Record "Sales Header";
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            CreateSalesDocument(SalesHeader."Document Type"::Order);
        end;
    end;

    procedure GenerateSalesShipments(HowMany: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            CreateSalesDocument(SalesHeader."Document Type"::Order);

            SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeader."No.");
            SalesHeader.Validate(Ship, true);
            SalesHeader.Validate(Invoice, false);
            SalesHeader.Modify(true);

            SalesPost.Run(SalesHeader);
        end;
    end;

    procedure GenerateSalesInvoices(HowMany: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            CreateSalesDocument(SalesHeader."Document Type"::Order);

            SalesHeader.Get(SalesHeader."Document Type"::Order, SalesHeader."No.");
            SalesHeader.Validate(Ship, true);
            SalesHeader.Validate(Invoice, true);
            SalesHeader.Modify(true);

            SalesPost.Run(SalesHeader);
        end;
    end;

    // ==================== TRANSACCIONES DE COMPRA ====================

    procedure GeneratePurchaseOrders(HowMany: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            CreatePurchaseDocument(PurchaseHeader."Document Type"::Order);
        end;
    end;

    procedure GeneratePurchaseReceipts(HowMany: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            CreatePurchaseDocument(PurchaseHeader."Document Type"::Order);

            PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchaseHeader."No.");
            PurchaseHeader.Validate(Receive, true);
            PurchaseHeader.Validate(Invoice, false);
            PurchaseHeader.Modify(true);

            PurchPost.Run(PurchaseHeader);
        end;
    end;

    procedure GeneratePurchaseInvoices(HowMany: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        i: Integer;
    begin
        for i := 1 to HowMany do begin
            CreatePurchaseDocument(PurchaseHeader."Document Type"::Order);

            PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchaseHeader."No.");
            PurchaseHeader.Validate(Receive, true);
            PurchaseHeader.Validate(Invoice, true);
            PurchaseHeader.Modify(true);

            PurchPost.Run(PurchaseHeader);
        end;
    end;

    // ==================== FUNCIONES AUXILIARES ====================

    local procedure CreateSalesDocument(DocType: Enum "Sales Document Type")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NumLines: Integer;
        i: Integer;
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", DocType);
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", GetRandomCustomerNo());
        SalesHeader.Validate("Posting Date", RandomHelper.GetRandomDate(CalcDate('<-60D>', Today), Today));
        SalesHeader.Validate("Document Date", SalesHeader."Posting Date");
        SalesHeader.Modify(true);

        NumLines := RandomHelper.GetRandomInteger(1, 5);

        for i := 1 to NumLines do begin
            Clear(SalesLine);
            SalesLine.Init();
            SalesLine.Validate("Document Type", SalesHeader."Document Type");
            SalesLine.Validate("Document No.", SalesHeader."No.");
            SalesLine.Validate("Line No.", i * 10000);
            SalesLine.Insert(true);

            SalesLine.Validate(Type, SalesLine.Type::Item);
            SalesLine.Validate("No.", GetRandomItemNo());
            SalesLine.Validate(Quantity, RandomHelper.GetRandomInteger(1, 20));
            SalesLine.Validate("Unit Price", RandomHelper.GetRandomDecimal(10, 500));
            SalesLine.Modify(true);
        end;
    end;

    local procedure CreatePurchaseDocument(DocType: Enum "Purchase Document Type")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        NumLines: Integer;
        i: Integer;
    begin
        PurchaseHeader.Init();
        PurchaseHeader.Validate("Document Type", DocType);
        PurchaseHeader.Insert(true);

        PurchaseHeader.Validate("Buy-from Vendor No.", GetRandomVendorNo());
        PurchaseHeader.Validate("Posting Date", RandomHelper.GetRandomDate(CalcDate('<-60D>', Today), Today));
        PurchaseHeader.Validate("Document Date", PurchaseHeader."Posting Date");
        PurchaseHeader.Modify(true);

        NumLines := RandomHelper.GetRandomInteger(1, 5);

        for i := 1 to NumLines do begin
            Clear(PurchaseLine);
            PurchaseLine.Init();
            PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
            PurchaseLine.Validate("Line No.", i * 10000);
            PurchaseLine.Insert(true);

            PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
            PurchaseLine.Validate("No.", GetRandomItemNo());
            PurchaseLine.Validate(Quantity, RandomHelper.GetRandomInteger(1, 50));
            PurchaseLine.Validate("Direct Unit Cost", RandomHelper.GetRandomDecimal(5, 300));
            PurchaseLine.Modify(true);
        end;
    end;

    local procedure CreateInitialInventory(ItemNo: Code[20]; Qty: Decimal)
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
        ItemJournalLine.Init();
        ItemJournalLine.Validate("Journal Template Name", GetItemJournalTemplate());
        ItemJournalLine.Validate("Journal Batch Name", GetItemJournalBatch());
        ItemJournalLine.Validate("Line No.", 10000);
        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
        ItemJournalLine.Validate("Posting Date", Today);
        ItemJournalLine.Validate("Document No.", 'INICIAL-' + ItemNo);
        ItemJournalLine.Validate("Item No.", ItemNo);
        ItemJournalLine.Validate(Quantity, Qty);
        ItemJournalLine.Validate("Location Code", GetDefaultLocation());

        ItemJnlPostLine.RunWithCheck(ItemJournalLine);
    end;

    // ==================== GETTERS DE CONFIGURACIÓN ====================

    local procedure GetNextCustomerNo(): Code[20]
    var
        Customer: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        SalesSetup.Get();
        exit(NoSeries.GetNextNo(SalesSetup."Customer Nos.", Today));
    end;

    local procedure GetNextVendorNo(): Code[20]
    var
        Vendor: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        PurchSetup.Get();
        exit(NoSeries.GetNextNo(PurchSetup."Vendor Nos.", Today));
    end;

    local procedure GetNextItemNo(): Code[20]
    var
        Item: Record Item;
        InvtSetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        InvtSetup.Get();
        exit(NoSeries.GetNextNo(InvtSetup."Item Nos.", Today));
    end;

    local procedure GetRandomCustomerNo(): Code[20]
    var
        Customer: Record Customer;
        RecordCount: Integer;
        RandomIndex: Integer;
    begin
        if Customer.FindSet() then begin
            RecordCount := Customer.Count;
            RandomIndex := RandomHelper.GetRandomInteger(1, RecordCount);
            Customer.Next(RandomIndex - 1);
            exit(Customer."No.");
        end;
        Error('No hay clientes disponibles. Genere clientes primero.');
    end;

    local procedure GetRandomVendorNo(): Code[20]
    var
        Vendor: Record Vendor;
        RecordCount: Integer;
        RandomIndex: Integer;
    begin
        if Vendor.FindSet() then begin
            RecordCount := Vendor.Count;
            RandomIndex := RandomHelper.GetRandomInteger(1, RecordCount);
            Vendor.Next(RandomIndex - 1);
            exit(Vendor."No.");
        end;
        Error('No hay proveedores disponibles. Genere proveedores primero.');
    end;

    local procedure GetRandomItemNo(): Code[20]
    var
        Item: Record Item;
        RecordCount: Integer;
        RandomIndex: Integer;
    begin
        Item.SetRange(Type, Item.Type::Inventory);
        if Item.FindSet() then begin
            RecordCount := Item.Count;
            RandomIndex := RandomHelper.GetRandomInteger(1, RecordCount);
            Item.Next(RandomIndex - 1);
            exit(Item."No.");
        end;
        Error('No hay productos disponibles. Genere productos primero.');
    end;

    local procedure GetDefaultGenBusPostingGroup(): Code[20]
    var
        GenBusPostingGroup: Record "Gen. Business Posting Group";
    begin
        if GenBusPostingGroup.FindFirst() then
            exit(GenBusPostingGroup.Code);
        exit('');
    end;

    local procedure GetDefaultVATBusPostingGroup(): Code[20]
    var
        VATBusPostingGroup: Record "VAT Business Posting Group";
    begin
        if VATBusPostingGroup.FindFirst() then
            exit(VATBusPostingGroup.Code);
        exit('');
    end;

    local procedure GetDefaultCustomerPostingGroup(): Code[20]
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        if CustomerPostingGroup.FindFirst() then
            exit(CustomerPostingGroup.Code);
        exit('');
    end;

    local procedure GetDefaultVendorPostingGroup(): Code[20]
    var
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        if VendorPostingGroup.FindFirst() then
            exit(VendorPostingGroup.Code);
        exit('');
    end;

    local procedure GetDefaultGenProdPostingGroup(): Code[20]
    var
        GenProdPostingGroup: Record "Gen. Product Posting Group";
    begin
        if GenProdPostingGroup.FindFirst() then
            exit(GenProdPostingGroup.Code);
        exit('');
    end;

    local procedure GetDefaultVATProdPostingGroup(): Code[20]
    var
        VATProdPostingGroup: Record "VAT Product Posting Group";
    begin
        if VATProdPostingGroup.FindFirst() then
            exit(VATProdPostingGroup.Code);
        exit('');
    end;

    local procedure GetDefaultInventoryPostingGroup(): Code[20]
    var
        InventoryPostingGroup: Record "Inventory Posting Group";
    begin
        if InventoryPostingGroup.FindFirst() then
            exit(InventoryPostingGroup.Code);
        exit('');
    end;

    local procedure GetDefaultPaymentTerms(): Code[10]
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if PaymentTerms.FindFirst() then
            exit(PaymentTerms.Code);
        exit('');
    end;

    local procedure GetDefaultPaymentMethod(): Code[10]
    var
        PaymentMethod: Record "Payment Method";
    begin
        if PaymentMethod.FindFirst() then
            exit(PaymentMethod.Code);
        exit('');
    end;

    local procedure GetDefaultUnitOfMeasure(): Code[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.FindFirst() then
            exit(UnitOfMeasure.Code);
        exit('PCS');
    end;

    local procedure GetDefaultLocation(): Code[10]
    var
        Location: Record Location;
    begin
        if Location.FindFirst() then
            exit(Location.Code);
        exit('');
    end;

    local procedure GetItemJournalTemplate(): Code[10]
    var
        ItemJournalTemplate: Record "Item Journal Template";
    begin
        ItemJournalTemplate.SetRange(Type, ItemJournalTemplate.Type::Item);
        if ItemJournalTemplate.FindFirst() then
            exit(ItemJournalTemplate.Name);
        exit('');
    end;

    local procedure GetItemJournalBatch(): Code[10]
    var
        ItemJournalBatch: Record "Item Journal Batch";
        TemplateName: Code[10];
    begin
        TemplateName := GetItemJournalTemplate();
        ItemJournalBatch.SetRange("Journal Template Name", TemplateName);
        if ItemJournalBatch.FindFirst() then
            exit(ItemJournalBatch.Name);
        exit('');
    end;
}
