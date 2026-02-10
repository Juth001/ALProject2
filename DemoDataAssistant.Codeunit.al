codeunit 50100 "Demo Data Assistant"
{
    procedure GenerateRandomDataV2(NoOfCustomers: Integer; NoOfVendors: Integer; NoOfItems: Integer;
                                  NoOfSalesOrders: Integer; NoOfPurchaseOrders: Integer;
                                  GenBusPostingGroup: Code[20]; VATBusPostingGroup: Code[20];
                                  CustPostingGroup: Code[20]; VendPostingGroup: Code[20];
                                  PaymentTermsCode: Code[10]; PaymentMethodCode: Code[10];
                                  GenProdPostingGroup: Code[20]; VATProdPostingGroup: Code[20];
                                  InvPostingGroup: Code[20]; UseRandomDates: Boolean; SpecificPostingDate: Date)
    var
        DemoDataGenerator: Codeunit "Demo Data Generator";
    begin
        // Establecer configuración
        DemoDataGenerator.SetConfigurationV2(
            GenBusPostingGroup, VATBusPostingGroup,
            CustPostingGroup, VendPostingGroup,
            PaymentTermsCode, PaymentMethodCode,
            GenProdPostingGroup, VATProdPostingGroup,
            InvPostingGroup, UseRandomDates, SpecificPostingDate
        );

        // Generar datos maestros
        if NoOfCustomers > 0 then
            DemoDataGenerator.CreateRandomCustomers(NoOfCustomers);

        if NoOfVendors > 0 then
            DemoDataGenerator.CreateRandomVendors(NoOfVendors);

        if NoOfItems > 0 then
            DemoDataGenerator.CreateRandomItems(NoOfItems);

        // Generar transacciones
        if NoOfSalesOrders > 0 then
            DemoDataGenerator.CreateRandomSalesDocuments(NoOfSalesOrders);

        if NoOfPurchaseOrders > 0 then
            DemoDataGenerator.CreateRandomPurchaseDocuments(NoOfPurchaseOrders);

        Message('Datos de demostración generados correctamente.');
    end;

    procedure ClearDemoData()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        Contact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        ConfirmMsg: Label '¿Está seguro de que desea eliminar todos los datos de demostración DEMO-*?';
        CustomerCount, VendorCount, ItemCount, ContactCount, SalesCount, PurchCount : Integer;
    begin
        if not Confirm(ConfirmMsg) then
            exit;

        // Eliminar pedidos de venta DEMO
        SalesHeader.SetFilter("Sell-to Customer No.", 'DEMO-C*');
        SalesCount := SalesHeader.Count;
        SalesHeader.DeleteAll(true);

        // Eliminar pedidos de compra DEMO
        PurchHeader.SetFilter("Buy-from Vendor No.", 'DEMO-V*');
        PurchCount := PurchHeader.Count;
        PurchHeader.DeleteAll(true);

        // Eliminar relaciones de negocio de contactos DEMO
        Contact.SetFilter("No.", 'DEMO-CONT-*|CT*');
        if Contact.FindSet() then
            repeat
                ContBusRel.SetRange("Contact No.", Contact."No.");
                ContBusRel.DeleteAll(true);
            until Contact.Next() = 0;

        // Eliminar contactos persona DEMO (primero las personas, luego las empresas)
        Contact.Reset();
        Contact.SetFilter("No.", 'DEMO-CONT-*|CT*');
        Contact.SetRange(Type, Contact.Type::Person);
        ContactCount := Contact.Count;
        Contact.DeleteAll(true);

        // Eliminar contactos empresa DEMO
        Contact.Reset();
        Contact.SetFilter("No.", 'DEMO-CONT-*|CT*');
        Contact.SetRange(Type, Contact.Type::Company);
        ContactCount += Contact.Count;
        Contact.DeleteAll(true);

        // Eliminar clientes DEMO
        Customer.SetFilter("No.", 'DEMO-C*');
        CustomerCount := Customer.Count;
        Customer.DeleteAll(true);

        // Eliminar proveedores DEMO
        Vendor.SetFilter("No.", 'DEMO-V*');
        VendorCount := Vendor.Count;
        Vendor.DeleteAll(true);

        // Eliminar productos DEMO
        Item.SetFilter("No.", 'DEMO-I*');
        ItemCount := Item.Count;
        Item.DeleteAll(true);

        Message('Datos eliminados:\%1 Clientes\%2 Proveedores\%3 Productos\%4 Contactos\%5 Pedidos de Venta\%6 Pedidos de Compra',
                CustomerCount, VendorCount, ItemCount, ContactCount, SalesCount, PurchCount);
    end;
}
