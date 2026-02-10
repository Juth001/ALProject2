page 50100 "Demo Data Assistant"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Asistente de Datos de Demostración';

    layout
    {
        area(Content)
        {
            group(MasterData)
            {
                Caption = 'Datos Maestros';

                field(NumCustomers; NumCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Clientes';
                    MinValue = 0;
                    MaxValue = 1000;
                }

                field(NumVendors; NumVendors)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Proveedores';
                    MinValue = 0;
                    MaxValue = 1000;
                }

                field(NumItems; NumItems)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Productos';
                    MinValue = 0;
                    MaxValue = 1000;
                }
            }

            group(SalesTransactions)
            {
                Caption = 'Transacciones de Venta';

                field(NumSalesOrders; NumSalesOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Pedidos de Venta';
                    MinValue = 0;
                    MaxValue = 1000;
                }

                field(NumSalesShipments; NumSalesShipments)
                {
                    ApplicationArea = All;
                    Caption = 'Albaranes de Venta';
                    MinValue = 0;
                    MaxValue = 1000;
                }

                field(NumSalesInvoices; NumSalesInvoices)
                {
                    ApplicationArea = All;
                    Caption = 'Facturas de Venta';
                    MinValue = 0;
                    MaxValue = 1000;
                }
            }

            group(PurchaseTransactions)
            {
                Caption = 'Transacciones de Compra';

                field(NumPurchaseOrders; NumPurchaseOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Pedidos de Compra';
                    MinValue = 0;
                    MaxValue = 1000;
                }

                field(NumPurchaseReceipts; NumPurchaseReceipts)
                {
                    ApplicationArea = All;
                    Caption = 'Albaranes de Compra';
                    MinValue = 0;
                    MaxValue = 1000;
                }

                field(NumPurchaseInvoices; NumPurchaseInvoices)
                {
                    ApplicationArea = All;
                    Caption = 'Facturas de Compra';
                    MinValue = 0;
                    MaxValue = 1000;
                }
            }

            group(Progress)
            {
                Caption = 'Progreso';
                Visible = ShowProgress;

                field(ProgressText; ProgressText)
                {
                    ApplicationArea = All;
                    Caption = 'Estado';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateAll)
            {
                ApplicationArea = All;
                Caption = 'Generar Todos los Datos';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm('¿Está seguro de que desea generar datos de demostración?', false) then
                        exit;

                    ShowProgress := true;
                    GenerateAllData();
                    ShowProgress := false;
                    Message('Generación de datos completada exitosamente.');
                end;
            }

            action(GenerateMasterData)
            {
                ApplicationArea = All;
                Caption = 'Generar Solo Datos Maestros';
                Image = ItemGroup;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowProgress := true;
                    GenerateMasterDataOnly();
                    ShowProgress := false;
                    Message('Datos maestros generados exitosamente.');
                end;
            }

            action(GenerateTransactions)
            {
                ApplicationArea = All;
                Caption = 'Generar Solo Transacciones';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowProgress := true;
                    GenerateTransactionsOnly();
                    ShowProgress := false;
                    Message('Transacciones generadas exitosamente.');
                end;
            }
        }
    }

    var
        NumCustomers: Integer;
        NumVendors: Integer;
        NumItems: Integer;
        NumSalesOrders: Integer;
        NumSalesShipments: Integer;
        NumSalesInvoices: Integer;
        NumPurchaseOrders: Integer;
        NumPurchaseReceipts: Integer;
        NumPurchaseInvoices: Integer;
        ProgressText: Text;
        ShowProgress: Boolean;
        DemoDataMgt: Codeunit "Demo Data Management";

    trigger OnOpenPage()
    begin
        // Valores por defecto
        NumCustomers := 10;
        NumVendors := 10;
        NumItems := 20;
        NumSalesOrders := 15;
        NumSalesShipments := 10;
        NumSalesInvoices := 10;
        NumPurchaseOrders := 15;
        NumPurchaseReceipts := 10;
        NumPurchaseInvoices := 10;
        ShowProgress := false;
    end;

    local procedure GenerateAllData()
    begin
        GenerateMasterDataOnly();
        GenerateTransactionsOnly();
    end;

    local procedure GenerateMasterDataOnly()
    begin
        if NumCustomers > 0 then begin
            ProgressText := 'Generando clientes...';
            CurrPage.Update(false);
            DemoDataMgt.GenerateCustomers(NumCustomers);
        end;

        if NumVendors > 0 then begin
            ProgressText := 'Generando proveedores...';
            CurrPage.Update(false);
            DemoDataMgt.GenerateVendors(NumVendors);
        end;

        if NumItems > 0 then begin
            ProgressText := 'Generando productos...';
            CurrPage.Update(false);
            DemoDataMgt.GenerateItems(NumItems);
        end;
    end;

    local procedure GenerateTransactionsOnly()
    begin
        if NumSalesOrders > 0 then begin
            ProgressText := 'Generando pedidos de venta...';
            CurrPage.Update(false);
            DemoDataMgt.GenerateSalesOrders(NumSalesOrders);
        end;

        if NumSalesShipments > 0 then begin
            ProgressText := 'Generando albaranes de venta...';
            CurrPage.Update(false);
            DemoDataMgt.GenerateSalesShipments(NumSalesShipments);
        end;

        if NumSalesInvoices > 0 then begin
            ProgressText := 'Generando facturas de venta...';
            CurrPage.Update(false);
            DemoDataMgt.GenerateSalesInvoices(NumSalesInvoices);
        end;

        if NumPurchaseOrders > 0 then begin
            ProgressText := 'Generando pedidos de compra...';
            CurrPage.Update(false);
            DemoDataMgt.GeneratePurchaseOrders(NumPurchaseOrders);
        end;

        if NumPurchaseReceipts > 0 then begin
            ProgressText := 'Generando albaranes de compra...';
            CurrPage.Update(false);
            DemoDataMgt.GeneratePurchaseReceipts(NumPurchaseReceipts);
        end;

        if NumPurchaseInvoices > 0 then begin
            ProgressText := 'Generando facturas de compra...';
            CurrPage.Update(false);
            DemoDataMgt.GeneratePurchaseInvoices(NumPurchaseInvoices);
        end;
    end;
}
