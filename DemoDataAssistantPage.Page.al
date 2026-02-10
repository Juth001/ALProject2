page 50100 "Demo Data Assistant Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Asistente de Datos de Demostración';

    layout
    {
        area(Content)
        {
            group(Configuration)
            {
                Caption = 'Configuración de Grupos de Registro';

                group(BusinessPosting)
                {
                    Caption = 'Grupos de Negocio';

                    field(GenBusPostingGroup; GenBusPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Grupo Registro Negocio General';
                        ToolTip = 'Especifica el grupo de registro de negocio general para clientes y proveedores';
                        TableRelation = "Gen. Business Posting Group";
                    }

                    field(VATBusPostingGroup; VATBusPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Grupo Registro IVA Negocio';
                        ToolTip = 'Especifica el grupo de registro de IVA de negocio para clientes y proveedores';
                        TableRelation = "VAT Business Posting Group";
                    }

                    field(CustPostingGroup; CustPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Grupo Registro Clientes';
                        ToolTip = 'Especifica el grupo de registro para clientes';
                        TableRelation = "Customer Posting Group";
                    }

                    field(VendPostingGroup; VendPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Grupo Registro Proveedores';
                        ToolTip = 'Especifica el grupo de registro para proveedores';
                        TableRelation = "Vendor Posting Group";
                    }
                }

                group(ProductPosting)
                {
                    Caption = 'Grupos de Producto';

                    field(GenProdPostingGroup; GenProdPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Grupo Registro Producto General';
                        ToolTip = 'Especifica el grupo de registro de producto general para productos';
                        TableRelation = "Gen. Product Posting Group";
                    }

                    field(VATProdPostingGroup; VATProdPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Grupo Registro IVA Producto';
                        ToolTip = 'Especifica el grupo de registro de IVA de producto para productos';
                        TableRelation = "VAT Product Posting Group";
                    }

                    field(InvPostingGroup; InvPostingGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Grupo Registro Inventario';
                        ToolTip = 'Especifica el grupo de registro de inventario para productos';
                        TableRelation = "Inventory Posting Group";
                    }
                }

                group(PaymentSettings)
                {
                    Caption = 'Configuración de Pago';

                    field(PaymentTermsCode; PaymentTermsCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Código Condiciones Pago';
                        ToolTip = 'Especifica el código de condiciones de pago';
                        TableRelation = "Payment Terms";
                    }

                    field(PaymentMethodCode; PaymentMethodCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Código Forma Pago';
                        ToolTip = 'Especifica el código de forma de pago';
                        TableRelation = "Payment Method";
                    }
                }
            }

            group(MasterData)
            {
                Caption = 'Datos Maestros';

                field(NoOfCustomers; NoOfCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Clientes';
                    ToolTip = 'Especifica cuántos clientes se crearán';
                }

                field(NoOfVendors; NoOfVendors)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Proveedores';
                    ToolTip = 'Especifica cuántos proveedores se crearán';
                }

                field(NoOfItems; NoOfItems)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Productos';
                    ToolTip = 'Especifica cuántos productos se crearán';
                }
            }

            group(Transactions)
            {
                Caption = 'Transacciones';

                group(DateConfiguration)
                {
                    Caption = 'Configuración de Fechas';

                    field(UseRandomDates; UseRandomDates)
                    {
                        ApplicationArea = All;
                        Caption = 'Usar Fechas Aleatorias';
                        ToolTip = 'Si está activado, los documentos tendrán fechas aleatorias entre hoy y 90 días atrás. Si está desactivado, se usará la fecha específica indicada abajo.';

                        trigger OnValidate()
                        begin
                            SpecificPostingDateEditable := not UseRandomDates;
                        end;
                    }

                    field(SpecificPostingDate; SpecificPostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Fecha Específica de Registro';
                        ToolTip = 'Fecha específica que se usará en todos los documentos (solo si "Usar Fechas Aleatorias" está desactivado)';
                        Editable = SpecificPostingDateEditable;
                    }
                }

                field(NoOfSalesOrders; NoOfSalesOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Pedidos de Venta';
                    ToolTip = 'Especifica cuántos pedidos de venta se crearán (se registrarán aleatoriamente)';
                }

                field(NoOfPurchaseOrders; NoOfPurchaseOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Número de Pedidos de Compra';
                    ToolTip = 'Especifica cuántos pedidos de compra se crearán (se registrarán aleatoriamente). Se generará automáticamente un número de documento del proveedor aleatorio.';
                }
            }

            group(Information)
            {
                Caption = 'Información';

                field(InfoText; InfoText)
                {
                    ApplicationArea = All;
                    Caption = '';
                    MultiLine = true;
                    Editable = false;
                    ShowCaption = false;
                    Style = Subordinate;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateData)
            {
                ApplicationArea = All;
                Caption = 'Generar Datos';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Genera los datos de demostración según los parámetros especificados';

                trigger OnAction()
                var
                    DemoDataAssistant: Codeunit "Demo Data Assistant";
                begin
                    // Validar que se han introducido los campos obligatorios
                    if GenBusPostingGroup = '' then
                        Error('Debe especificar el Grupo Registro Negocio General');
                    if VATBusPostingGroup = '' then
                        Error('Debe especificar el Grupo Registro IVA Negocio');
                    if CustPostingGroup = '' then
                        Error('Debe especificar el Grupo Registro Clientes');
                    if VendPostingGroup = '' then
                        Error('Debe especificar el Grupo Registro Proveedores');
                    if GenProdPostingGroup = '' then
                        Error('Debe especificar el Grupo Registro Producto General');
                    if VATProdPostingGroup = '' then
                        Error('Debe especificar el Grupo Registro IVA Producto');
                    if InvPostingGroup = '' then
                        Error('Debe especificar el Grupo Registro Inventario');
                    if PaymentTermsCode = '' then
                        Error('Debe especificar el Código Condiciones Pago');
                    if PaymentMethodCode = '' then
                        Error('Debe especificar el Código Forma Pago');

                    // Validar configuración de fechas
                    if (not UseRandomDates) and (SpecificPostingDate = 0D) then
                        Error('Debe especificar una Fecha Específica de Registro o activar Usar Fechas Aleatorias');

                    if not Confirm('¿Desea generar los datos de demostración?', false) then
                        exit;

                    DemoDataAssistant.GenerateRandomDataV2(
                        NoOfCustomers,
                        NoOfVendors,
                        NoOfItems,
                        NoOfSalesOrders,
                        NoOfPurchaseOrders,
                        GenBusPostingGroup,
                        VATBusPostingGroup,
                        CustPostingGroup,
                        VendPostingGroup,
                        PaymentTermsCode,
                        PaymentMethodCode,
                        GenProdPostingGroup,
                        VATProdPostingGroup,
                        InvPostingGroup,
                        UseRandomDates,
                        SpecificPostingDate
                    );

                    Message('Proceso completado. Revise los datos creados.');
                end;
            }

            action(ViewCustomers)
            {
                ApplicationArea = All;
                Caption = 'Ver Clientes';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Abre la lista de clientes';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustomerList: Page "Customer List";
                begin
                    Customer.SetFilter("No.", 'DEMO-C*');
                    CustomerList.SetTableView(Customer);
                    CustomerList.Run();
                end;
            }

            action(ViewVendors)
            {
                ApplicationArea = All;
                Caption = 'Ver Proveedores';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Abre la lista de proveedores';

                trigger OnAction()
                var
                    Vendor: Record Vendor;
                    VendorList: Page "Vendor List";
                begin
                    Vendor.SetFilter("No.", 'DEMO-V*');
                    VendorList.SetTableView(Vendor);
                    VendorList.Run();
                end;
            }

            action(ViewItems)
            {
                ApplicationArea = All;
                Caption = 'Ver Productos';
                Image = Item;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Abre la lista de productos';

                trigger OnAction()
                var
                    Item: Record Item;
                    ItemList: Page "Item List";
                begin
                    Item.SetFilter("No.", 'DEMO-I*');
                    ItemList.SetTableView(Item);
                    ItemList.Run();
                end;
            }

            action(ViewContacts)
            {
                ApplicationArea = All;
                Caption = 'Ver Contactos (Personas)';
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Abre la lista de personas de contacto generadas';

                trigger OnAction()
                var
                    Contact: Record Contact;
                    ContactList: Page "Contact List";
                begin
                    Contact.SetRange(Type, Contact.Type::Person);
                    Contact.SetFilter("Company No.", '<>%1', '');
                    ContactList.SetTableView(Contact);
                    ContactList.Run();
                end;
            }

            action(ViewSalesOrders)
            {
                ApplicationArea = All;
                Caption = 'Ver Pedidos de Venta';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Abre la lista de pedidos de venta';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesOrderList: Page "Sales Order List";
                begin
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesOrderList.SetTableView(SalesHeader);
                    SalesOrderList.Run();
                end;
            }

            action(ViewPurchaseOrders)
            {
                ApplicationArea = All;
                Caption = 'Ver Pedidos de Compra';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category5;
                ToolTip = 'Abre la lista de pedidos de compra';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseOrderList: Page "Purchase Order List";
                begin
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseOrderList.SetTableView(PurchaseHeader);
                    PurchaseOrderList.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Valores por defecto para cantidades
        NoOfCustomers := 10;
        NoOfVendors := 5;
        NoOfItems := 20;
        NoOfSalesOrders := 15;
        NoOfPurchaseOrders := 10;

        // Configuración de fechas por defecto
        UseRandomDates := true;
        SpecificPostingDate := Today;
        SpecificPostingDateEditable := false;

        InfoText := 'Este asistente crea datos de demostración para Business Central. ' +
                    'Los datos maestros (clientes, proveedores y productos) se identifican con el prefijo "DEMO-". ' +
                    'Las transacciones se crean automáticamente y algunas se registran de forma aleatoria. ' +
                    'Los pedidos pueden convertirse en albaranes y facturas según la probabilidad configurada. ' +
                    'IMPORTANTE: Configure los grupos de registro según su empresa antes de generar los datos. ' +
                    'Los pedidos de compra incluirán números de documento de proveedor aleatorios.';
    end;

    var
        NoOfCustomers: Integer;
        NoOfVendors: Integer;
        NoOfItems: Integer;
        NoOfSalesOrders: Integer;
        NoOfPurchaseOrders: Integer;
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
        SpecificPostingDateEditable: Boolean;
        InfoText: Text;
}
