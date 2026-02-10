codeunit 50101 "Demo Data Generator"
{
    var
        FirstNames: List of [Text];
        LastNames: List of [Text];
        CompanyNames: List of [Text];
        Streets: List of [Text];
        Cities: List of [Text];
        ItemCategories: List of [Text];
        ItemDescriptions: List of [Text];
        GenBusPostingGroup: Code[20];
        VATBusPostingGroup: Code[20];
        CustPostingGroup: Code[20];
        VendPostingGroup: Code[20];
        PaymentTermsCode: Code[10];
        PaymentMethodCode: Code[10];
        GenProdPostingGroup: Code[20];
        VATProdPostingGroup: Code[20];
        InvPostingGroup: Code[20];
        UseRandomDates: Boolean;
        SpecificPostingDate: Date;

    procedure SetConfigurationV2(NewGenBusPostingGroup: Code[20]; NewVATBusPostingGroup: Code[20];
                               NewCustPostingGroup: Code[20]; NewVendPostingGroup: Code[20];
                               NewPaymentTermsCode: Code[10]; NewPaymentMethodCode: Code[10];
                               NewGenProdPostingGroup: Code[20]; NewVATProdPostingGroup: Code[20];
                               NewInvPostingGroup: Code[20]; NewUseRandomDates: Boolean; NewSpecificPostingDate: Date)
    begin
        GenBusPostingGroup := NewGenBusPostingGroup;
        VATBusPostingGroup := NewVATBusPostingGroup;
        CustPostingGroup := NewCustPostingGroup;
        VendPostingGroup := NewVendPostingGroup;
        PaymentTermsCode := NewPaymentTermsCode;
        PaymentMethodCode := NewPaymentMethodCode;
        GenProdPostingGroup := NewGenProdPostingGroup;
        VATProdPostingGroup := NewVATProdPostingGroup;
        InvPostingGroup := NewInvPostingGroup;
        UseRandomDates := NewUseRandomDates;
        SpecificPostingDate := NewSpecificPostingDate;
    end;

    procedure InitializeNameLists()
    begin
        // Verificar/Crear códigos de relación de negocio
        VerifyBusinessRelations();

        // Nombres
        FirstNames.Add('Juan');
        FirstNames.Add('María');
        FirstNames.Add('Pedro');
        FirstNames.Add('Ana');
        FirstNames.Add('Carlos');
        FirstNames.Add('Laura');
        FirstNames.Add('Miguel');
        FirstNames.Add('Carmen');
        FirstNames.Add('José');
        FirstNames.Add('Isabel');

        // Apellidos
        LastNames.Add('García');
        LastNames.Add('Rodríguez');
        LastNames.Add('Martínez');
        LastNames.Add('López');
        LastNames.Add('González');
        LastNames.Add('Fernández');
        LastNames.Add('Sánchez');
        LastNames.Add('Pérez');
        LastNames.Add('Gómez');
        LastNames.Add('Martín');

        // Nombres de empresas
        CompanyNames.Add('Tecnología Avanzada S.L.');
        CompanyNames.Add('Distribuciones Comerciales S.A.');
        CompanyNames.Add('Servicios Integrales Ibérica');
        CompanyNames.Add('Grupo Empresarial Mediterráneo');
        CompanyNames.Add('Sistemas y Soluciones España');
        CompanyNames.Add('Innovación Digital S.L.');
        CompanyNames.Add('Logística y Transporte Nacional');
        CompanyNames.Add('Consultoría Estratégica Global');
        CompanyNames.Add('Industrias Manufactureras Unidas');
        CompanyNames.Add('Comercio Internacional Hispano');

        // Calles
        Streets.Add('Calle Mayor');
        Streets.Add('Avenida de la Constitución');
        Streets.Add('Plaza de España');
        Streets.Add('Calle Gran Vía');
        Streets.Add('Paseo de la Castellana');
        Streets.Add('Calle del Carmen');
        Streets.Add('Avenida del Mediterráneo');
        Streets.Add('Calle de Alcalá');

        // Ciudades
        Cities.Add('Madrid');
        Cities.Add('Barcelona');
        Cities.Add('Valencia');
        Cities.Add('Sevilla');
        Cities.Add('Zaragoza');
        Cities.Add('Málaga');
        Cities.Add('Bilbao');
        Cities.Add('Alicante');

        // Categorías de productos
        ItemCategories.Add('Electrónica');
        ItemCategories.Add('Material Oficina');
        ItemCategories.Add('Hardware');
        ItemCategories.Add('Software');
        ItemCategories.Add('Mobiliario');
        ItemCategories.Add('Consumibles');

        // Descripciones de productos
        ItemDescriptions.Add('Ordenador portátil');
        ItemDescriptions.Add('Monitor LED');
        ItemDescriptions.Add('Teclado inalámbrico');
        ItemDescriptions.Add('Ratón óptico');
        ItemDescriptions.Add('Impresora láser');
        ItemDescriptions.Add('Papel A4');
        ItemDescriptions.Add('Tóner');
        ItemDescriptions.Add('Silla ergonómica');
        ItemDescriptions.Add('Mesa oficina');
        ItemDescriptions.Add('Archivador');
    end;

    procedure CreateRandomCustomers(NoOfCustomers: Integer)
    var
        Customer: Record Customer;
        Contact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        i: Integer;
        CustomerNo: Code[20];
        CompanyContactNo: Code[20];
        FirstName: Text[30];
        LastName: Text[30];
    begin
        InitializeNameLists();

        for i := 1 to NoOfCustomers do begin
            Customer.Init();
            CustomerNo := 'DEMO-C' + Format(i, 0, '<Integer,5><Filler Character,0>');

            // Verificar si ya existe
            if Customer.Get(CustomerNo) then
                continue;

            Customer.Validate("No.", CustomerNo);
            Customer.Validate(Name, GetRandomCompanyName());
            Customer.Validate(Address, GetRandomStreet() + ', ' + Format(GetRandomNumber(1, 200)));
            Customer.Validate(City, GetRandomCity());
            Customer.Validate("Post Code", Format(GetRandomNumber(10000, 99999)));
            Customer.Validate("Country/Region Code", 'ES');
            Customer.Validate("Phone No.", '+34' + Format(GetRandomNumber(600000000, 699999999)));
            Customer.Validate("E-Mail", LowerCase(CopyStr(Customer.Name, 1, 10)) + '@demo.com');
            Customer.Validate("Gen. Bus. Posting Group", GenBusPostingGroup);
            Customer.Validate("VAT Bus. Posting Group", VATBusPostingGroup);
            Customer.Validate("Customer Posting Group", CustPostingGroup);
            Customer.Validate("Payment Terms Code", PaymentTermsCode);
            Customer.Validate("Payment Method Code", PaymentMethodCode);

            if Customer.Insert(true) then begin
                // BC crea el contacto de empresa automáticamente
                // Buscar el contacto que BC creó
                ContBusRel.Reset();
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SetRange("No.", Customer."No.");
                if ContBusRel.FindFirst() then begin
                    CompanyContactNo := ContBusRel."Contact No.";

                    // Crear persona de contacto dentro de la empresa
                    FirstName := GetRandomFirstName();
                    LastName := GetRandomLastName();

                    Clear(Contact);
                    Contact.Init();
                    Contact.Validate(Type, Contact.Type::Person);
                    Contact.Validate("Company No.", CompanyContactNo);
                    Contact.Insert(true);

                    // Actualizar campos de la persona
                    Contact.Validate(Name, FirstName + ' ' + LastName);
                    Contact.Validate("First Name", FirstName);
                    Contact.Validate(Surname, LastName);
                    Contact.Validate("Job Title", GetRandomJobTitle());
                    Contact.Validate("Phone No.", Customer."Phone No.");
                    Contact.Validate("E-Mail", LowerCase(FirstName) + '.' + LowerCase(LastName) + '@demo.com');
                    Contact.Modify(true);
                end;
            end;
        end;

        Message('Se han creado %1 clientes con sus contactos de persona.', NoOfCustomers);
    end;

    procedure CreateRandomVendors(NoOfVendors: Integer)
    var
        Vendor: Record Vendor;
        Contact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        i: Integer;
        VendorNo: Code[20];
        CompanyContactNo: Code[20];
        FirstName: Text[30];
        LastName: Text[30];
    begin
        InitializeNameLists();

        for i := 1 to NoOfVendors do begin
            Vendor.Init();
            VendorNo := 'DEMO-V' + Format(i, 0, '<Integer,5><Filler Character,0>');

            // Verificar si ya existe
            if Vendor.Get(VendorNo) then
                continue;

            Vendor.Validate("No.", VendorNo);
            Vendor.Validate(Name, GetRandomCompanyName());
            Vendor.Validate(Address, GetRandomStreet() + ', ' + Format(GetRandomNumber(1, 200)));
            Vendor.Validate(City, GetRandomCity());
            Vendor.Validate("Post Code", Format(GetRandomNumber(10000, 99999)));
            Vendor.Validate("Country/Region Code", 'ES');
            Vendor.Validate("Phone No.", '+34' + Format(GetRandomNumber(900000000, 999999999)));
            Vendor.Validate("E-Mail", LowerCase(CopyStr(Vendor.Name, 1, 10)) + '@proveedor.com');
            Vendor.Validate("Gen. Bus. Posting Group", GenBusPostingGroup);
            Vendor.Validate("VAT Bus. Posting Group", VATBusPostingGroup);
            Vendor.Validate("Vendor Posting Group", VendPostingGroup);
            Vendor.Validate("Payment Terms Code", PaymentTermsCode);
            Vendor.Validate("Payment Method Code", PaymentMethodCode);

            if Vendor.Insert(true) then begin
                // BC crea el contacto de empresa automáticamente
                // Buscar el contacto que BC creó
                ContBusRel.Reset();
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SetRange("No.", Vendor."No.");
                if ContBusRel.FindFirst() then begin
                    CompanyContactNo := ContBusRel."Contact No.";

                    // Crear persona de contacto dentro de la empresa
                    FirstName := GetRandomFirstName();
                    LastName := GetRandomLastName();

                    Clear(Contact);
                    Contact.Init();
                    Contact.Validate(Type, Contact.Type::Person);
                    Contact.Validate("Company No.", CompanyContactNo);
                    Contact.Insert(true);

                    // Actualizar campos de la persona
                    Contact.Validate(Name, FirstName + ' ' + LastName);
                    Contact.Validate("First Name", FirstName);
                    Contact.Validate(Surname, LastName);
                    Contact.Validate("Job Title", GetRandomJobTitle());
                    Contact.Validate("Phone No.", Vendor."Phone No.");
                    Contact.Validate("E-Mail", LowerCase(FirstName) + '.' + LowerCase(LastName) + '@proveedor.com');
                    Contact.Modify(true);
                end;
            end;
        end;

        Message('Se han creado %1 proveedores con sus contactos de persona.', NoOfVendors);
    end;

    procedure CreateRandomItems(NoOfItems: Integer)
    var
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        UnitOfMeasure: Record "Unit of Measure";
        i: Integer;
        ItemNo: Code[20];
    begin
        InitializeNameLists();

        // Verificar/crear unidad de medida 'UDS'
        if not UnitOfMeasure.Get('UDS') then begin
            UnitOfMeasure.Init();
            UnitOfMeasure.Validate(Code, 'UDS');
            UnitOfMeasure.Validate(Description, 'Unidades');
            UnitOfMeasure.Insert(true);
        end;

        for i := 1 to NoOfItems do begin
            Item.Init();
            ItemNo := 'DEMO-I' + Format(i, 0, '<Integer,5><Filler Character,0>');

            // Verificar si ya existe
            if Item.Get(ItemNo) then
                continue;

            Item.Validate("No.", ItemNo);
            Item.Validate(Description, GetRandomItemDescription());
            Item.Validate("Gen. Prod. Posting Group", GenProdPostingGroup);
            Item.Validate("VAT Prod. Posting Group", VATProdPostingGroup);
            Item.Validate("Inventory Posting Group", InvPostingGroup);
            Item.Validate("Unit Price", GetRandomNumber(10, 1000));
            Item.Validate("Unit Cost", Item."Unit Price" * 0.6);

            // Insertar sin Base Unit of Measure
            if Item.Insert(true) then begin
                // Crear Item Unit of Measure
                ItemUnitOfMeasure.Init();
                ItemUnitOfMeasure.Validate("Item No.", Item."No.");
                ItemUnitOfMeasure.Validate(Code, 'UDS');
                ItemUnitOfMeasure.Validate("Qty. per Unit of Measure", 1);
                ItemUnitOfMeasure.Insert(true);

                // Ahora actualizar el Item con Base Unit of Measure
                Item.Validate("Base Unit of Measure", 'UDS');
                Item.Modify(true);

                // Establecer inventario directamente
                Item.Inventory := GetRandomNumber(10, 100);
                Item.Modify(false);
            end;
        end;

        Message('Se han creado %1 productos.', NoOfItems);
    end;

    procedure CreateRandomSalesDocuments(NoOfSalesOrders: Integer)
    var
        i: Integer;
    begin
        for i := 1 to NoOfSalesOrders do
            CreateSalesOrder();
    end;

    procedure CreateRandomPurchaseDocuments(NoOfPurchaseOrders: Integer)
    var
        i: Integer;
    begin
        for i := 1 to NoOfPurchaseOrders do
            CreatePurchaseOrder();
    end;

    local procedure CreateSalesOrder()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        Item: Record Item;
        NoOfLines: Integer;
        i: Integer;
        DocDate: Date;
    begin
        if not GetRandomCustomer(Customer) then
            exit;

        DocDate := GetDocumentDate();

        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", Customer."No.");
        SalesHeader.Validate("Posting Date", DocDate);
        SalesHeader.Validate("Order Date", DocDate);
        SalesHeader.Modify(true);

        NoOfLines := GetRandomNumber(1, 5);
        for i := 1 to NoOfLines do begin
            if GetRandomItem(Item) then begin
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", i * 10000);
                SalesLine.Insert(true);
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", Item."No.");
                SalesLine.Validate(Quantity, GetRandomNumber(1, 10));
                SalesLine.Modify(true);
            end;
        end;

        if GetRandomNumber(1, 100) > 30 then begin
            PostSalesShipment(SalesHeader);
            if GetRandomNumber(1, 100) > 40 then
                PostSalesInvoice(SalesHeader);
        end;
    end;

    local procedure CreatePurchaseOrder()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Vendor: Record Vendor;
        Item: Record Item;
        NoOfLines: Integer;
        i: Integer;
        VendorDocNo: Code[35];
        DocDate: Date;
    begin
        if not GetRandomVendor(Vendor) then
            exit;

        VendorDocNo := 'PROV-' + Format(GetRandomNumber(10000, 99999)) + '-' + Format(GetRandomNumber(100, 999));
        DocDate := GetDocumentDate();

        PurchaseHeader.Init();
        PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.Insert(true);
        PurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");
        PurchaseHeader.Validate("Vendor Invoice No.", VendorDocNo);
        PurchaseHeader.Validate("Posting Date", DocDate);
        PurchaseHeader.Validate("Order Date", DocDate);
        PurchaseHeader.Modify(true);

        NoOfLines := GetRandomNumber(1, 5);
        for i := 1 to NoOfLines do begin
            if GetRandomItem(Item) then begin
                PurchaseLine.Init();
                PurchaseLine.Validate("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.Validate("Document No.", PurchaseHeader."No.");
                PurchaseLine.Validate("Line No.", i * 10000);
                PurchaseLine.Insert(true);
                PurchaseLine.Validate(Type, PurchaseLine.Type::Item);
                PurchaseLine.Validate("No.", Item."No.");
                PurchaseLine.Validate(Quantity, GetRandomNumber(1, 20));
                PurchaseLine.Modify(true);
            end;
        end;

        if GetRandomNumber(1, 100) > 30 then begin
            PostPurchaseReceipt(PurchaseHeader);
            if GetRandomNumber(1, 100) > 40 then
                PostPurchaseInvoice(PurchaseHeader);
        end;
    end;

    local procedure PostSalesShipment(var SalesHeader: Record "Sales Header")
    var
        SalesPost: Codeunit "Sales-Post";
    begin
        SalesHeader.Validate(Ship, true);
        SalesHeader.Validate(Invoice, false);
        SalesHeader.Modify(true);
        SalesPost.Run(SalesHeader);
    end;

    local procedure PostSalesInvoice(var SalesHeader: Record "Sales Header")
    var
        SalesPost: Codeunit "Sales-Post";
    begin
        if SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
            SalesHeader.Validate(Ship, false);
            SalesHeader.Validate(Invoice, true);
            SalesHeader.Modify(true);
            SalesPost.Run(SalesHeader);
        end;
    end;

    local procedure PostPurchaseReceipt(var PurchaseHeader: Record "Purchase Header")
    var
        PurchPost: Codeunit "Purch.-Post";
    begin
        PurchaseHeader.Validate(Receive, true);
        PurchaseHeader.Validate(Invoice, false);
        PurchaseHeader.Modify(true);
        PurchPost.Run(PurchaseHeader);
    end;

    local procedure PostPurchaseInvoice(var PurchaseHeader: Record "Purchase Header")
    var
        PurchPost: Codeunit "Purch.-Post";
    begin
        if PurchaseHeader.Get(PurchaseHeader."Document Type", PurchaseHeader."No.") then begin
            PurchaseHeader.Validate(Receive, false);
            PurchaseHeader.Validate(Invoice, true);
            PurchaseHeader.Modify(true);
            PurchPost.Run(PurchaseHeader);
        end;
    end;

    // Funciones auxiliares
    local procedure VerifyBusinessRelations()
    var
        BusinessRelation: Record "Business Relation";
    begin
        if not BusinessRelation.Get('CLIENTE') then begin
            BusinessRelation.Init();
            BusinessRelation.Validate(Code, 'CLIENTE');
            BusinessRelation.Validate(Description, 'Cliente');
            BusinessRelation.Insert(true);
        end;

        if not BusinessRelation.Get('PROVEEDOR') then begin
            BusinessRelation.Init();
            BusinessRelation.Validate(Code, 'PROVEEDOR');
            BusinessRelation.Validate(Description, 'Proveedor');
            BusinessRelation.Insert(true);
        end;
    end;

    local procedure GetRandomNumber(MinValue: Integer; MaxValue: Integer): Integer
    begin
        exit(MinValue + Random(MaxValue - MinValue + 1) - 1);
    end;

    local procedure GetDocumentDate(): Date
    var
        DaysBack: Integer;
    begin
        if UseRandomDates then begin
            DaysBack := GetRandomNumber(0, 90);
            exit(CalcDate('<-' + Format(DaysBack) + 'D>', Today));
        end else begin
            if SpecificPostingDate <> 0D then
                exit(SpecificPostingDate)
            else
                exit(Today);
        end;
    end;

    local procedure GetRandomFirstName(): Text[30]
    var
        Index: Integer;
    begin
        Index := GetRandomNumber(1, FirstNames.Count);
        exit(CopyStr(FirstNames.Get(Index), 1, 30));
    end;

    local procedure GetRandomLastName(): Text[30]
    var
        Index: Integer;
    begin
        Index := GetRandomNumber(1, LastNames.Count);
        exit(CopyStr(LastNames.Get(Index), 1, 30));
    end;

    local procedure GetRandomJobTitle(): Text[50]
    var
        JobTitles: List of [Text];
        Index: Integer;
    begin
        JobTitles.Add('Director Comercial');
        JobTitles.Add('Gerente de Compras');
        JobTitles.Add('Responsable de Ventas');
        JobTitles.Add('Director Financiero');
        JobTitles.Add('Jefe de Administración');
        JobTitles.Add('Coordinador de Logística');
        JobTitles.Add('Responsable de Operaciones');
        JobTitles.Add('Director General');
        JobTitles.Add('Gerente de Cuentas');
        JobTitles.Add('Responsable de Atención al Cliente');

        Index := GetRandomNumber(1, JobTitles.Count);
        exit(CopyStr(JobTitles.Get(Index), 1, 50));
    end;

    local procedure GetRandomCustomer(var Customer: Record Customer): Boolean
    begin
        Customer.SetFilter("No.", 'DEMO-C*');
        if Customer.FindSet() then begin
            Customer.Next(GetRandomNumber(0, Customer.Count - 1));
            exit(true);
        end;
        exit(false);
    end;

    local procedure GetRandomVendor(var Vendor: Record Vendor): Boolean
    begin
        Vendor.SetFilter("No.", 'DEMO-V*');
        if Vendor.FindSet() then begin
            Vendor.Next(GetRandomNumber(0, Vendor.Count - 1));
            exit(true);
        end;
        exit(false);
    end;

    local procedure GetRandomItem(var Item: Record Item): Boolean
    begin
        Item.SetFilter("No.", 'DEMO-I*');
        if Item.FindSet() then begin
            Item.Next(GetRandomNumber(0, Item.Count - 1));
            exit(true);
        end;
        exit(false);
    end;

    local procedure GetRandomCompanyName(): Text[100]
    var
        Index: Integer;
    begin
        Index := GetRandomNumber(1, CompanyNames.Count);
        exit(CopyStr(CompanyNames.Get(Index), 1, 100));
    end;

    local procedure GetRandomStreet(): Text[100]
    var
        Index: Integer;
    begin
        Index := GetRandomNumber(1, Streets.Count);
        exit(CopyStr(Streets.Get(Index), 1, 100));
    end;

    local procedure GetRandomCity(): Text[30]
    var
        Index: Integer;
    begin
        Index := GetRandomNumber(1, Cities.Count);
        exit(CopyStr(Cities.Get(Index), 1, 30));
    end;

    local procedure GetRandomItemDescription(): Text[100]
    var
        Category: Text;
        Description: Text;
        CategoryIndex: Integer;
        DescIndex: Integer;
    begin
        CategoryIndex := GetRandomNumber(1, ItemCategories.Count);
        DescIndex := GetRandomNumber(1, ItemDescriptions.Count);
        Category := ItemCategories.Get(CategoryIndex);
        Description := ItemDescriptions.Get(DescIndex);
        exit(CopyStr(Description + ' - ' + Category, 1, 100));
    end;
}
