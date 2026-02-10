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
}
