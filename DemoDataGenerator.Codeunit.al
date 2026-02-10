codeunit 50101 "Random Helper"
{
    var
        CompanyNames: List of [Text];
        FirstNames: List of [Text];
        LastNames: List of [Text];
        Streets: List of [Text];
        Cities: List of [Text];
        ItemPrefixes: List of [Text];
        ItemCategories: List of [Text];

    trigger OnRun()
    begin
        InitializeLists();
    end;

    procedure GetRandomCompanyName(): Text[100]
    var
        CompanySuffixes: List of [Text];
        RandomIndex: Integer;
        CompanyName: Text;
    begin
        if CompanyNames.Count = 0 then
            InitializeLists();

        CompanySuffixes.Add('S.L.');
        CompanySuffixes.Add('S.A.');
        CompanySuffixes.Add('Ltda.');
        CompanySuffixes.Add('Inc.');
        CompanySuffixes.Add('Corp.');
        CompanySuffixes.Add('Group');
        CompanySuffixes.Add('Enterprises');
        CompanySuffixes.Add('Solutions');

        RandomIndex := GetRandomInteger(1, CompanyNames.Count);
        CompanyName := CompanyNames.Get(RandomIndex);

        if GetRandomInteger(1, 2) = 1 then begin
            RandomIndex := GetRandomInteger(1, CompanySuffixes.Count);
            CompanyName := CompanyName + ' ' + CompanySuffixes.Get(RandomIndex);
        end;

        exit(CopyStr(CompanyName, 1, 100));
    end;

    procedure GetRandomPersonName(): Text[100]
    var
        RandomFirstName: Text;
        RandomLastName: Text;
        RandomIndex: Integer;
    begin
        if FirstNames.Count = 0 then
            InitializeLists();

        RandomIndex := GetRandomInteger(1, FirstNames.Count);
        RandomFirstName := FirstNames.Get(RandomIndex);

        RandomIndex := GetRandomInteger(1, LastNames.Count);
        RandomLastName := LastNames.Get(RandomIndex);

        exit(CopyStr(RandomFirstName + ' ' + RandomLastName, 1, 100));
    end;

    procedure GetRandomAddress(): Text[100]
    var
        RandomIndex: Integer;
        StreetName: Text;
        StreetNumber: Integer;
    begin
        if Streets.Count = 0 then
            InitializeLists();

        RandomIndex := GetRandomInteger(1, Streets.Count);
        StreetName := Streets.Get(RandomIndex);
        StreetNumber := GetRandomInteger(1, 999);

        exit(CopyStr(StreetName + ' ' + Format(StreetNumber), 1, 100));
    end;

    procedure GetRandomCity(): Text[30]
    var
        RandomIndex: Integer;
    begin
        if Cities.Count = 0 then
            InitializeLists();

        RandomIndex := GetRandomInteger(1, Cities.Count);
        exit(CopyStr(Cities.Get(RandomIndex), 1, 30));
    end;

    procedure GetRandomPostCode(): Code[20]
    var
        PostCode: Integer;
    begin
        PostCode := GetRandomInteger(1000, 99999);
        exit(Format(PostCode));
    end;

    procedure GetRandomCountryCode(): Code[10]
    var
        CountryCodes: List of [Text];
        RandomIndex: Integer;
    begin
        CountryCodes.Add('ES');
        CountryCodes.Add('US');
        CountryCodes.Add('GB');
        CountryCodes.Add('FR');
        CountryCodes.Add('DE');
        CountryCodes.Add('IT');

        RandomIndex := GetRandomInteger(1, CountryCodes.Count);
        exit(CopyStr(CountryCodes.Get(RandomIndex), 1, 10));
    end;

    procedure GetRandomPhoneNumber(): Text[30]
    var
        PhoneNumber: Text;
        i: Integer;
    begin
        PhoneNumber := '+34 ';
        for i := 1 to 9 do
            PhoneNumber := PhoneNumber + Format(GetRandomInteger(0, 9));

        exit(CopyStr(PhoneNumber, 1, 30));
    end;

    procedure GetRandomEmail(BaseName: Text): Text[80]
    var
        Domains: List of [Text];
        RandomIndex: Integer;
        CleanName: Text;
        Email: Text;
    begin
        Domains.Add('example.com');
        Domains.Add('demo.com');
        Domains.Add('test.com');
        Domains.Add('sample.com');
        Domains.Add('business.com');

        CleanName := DelChr(BaseName, '=', ' .,;-');
        CleanName := LowerCase(CleanName);

        RandomIndex := GetRandomInteger(1, Domains.Count);
        Email := CopyStr(CleanName, 1, 30) + '@' + Domains.Get(RandomIndex);

        exit(CopyStr(Email, 1, 80));
    end;

    procedure GetRandomItemDescription(): Text[100]
    var
        RandomPrefixIndex: Integer;
        RandomCategoryIndex: Integer;
        RandomNumber: Integer;
        Description: Text;
    begin
        if ItemPrefixes.Count = 0 then
            InitializeLists();

        RandomPrefixIndex := GetRandomInteger(1, ItemPrefixes.Count);
        RandomCategoryIndex := GetRandomInteger(1, ItemCategories.Count);
        RandomNumber := GetRandomInteger(100, 999);

        Description := ItemPrefixes.Get(RandomPrefixIndex) + ' ' +
                      ItemCategories.Get(RandomCategoryIndex) + ' ' +
                      Format(RandomNumber);

        exit(CopyStr(Description, 1, 100));
    end;

    procedure GetRandomInteger(MinValue: Integer; MaxValue: Integer): Integer
    begin
        if MaxValue <= MinValue then
            exit(MinValue);

        exit(MinValue + Random(MaxValue - MinValue + 1) - 1);
    end;

    procedure GetRandomDecimal(MinValue: Decimal; MaxValue: Decimal): Decimal
    var
        RandomInt: Integer;
        Range: Decimal;
        Result: Decimal;
    begin
        if MaxValue <= MinValue then
            exit(MinValue);

        Range := MaxValue - MinValue;
        RandomInt := Random(10000);
        Result := MinValue + (Range * RandomInt / 10000);

        exit(Round(Result, 0.01));
    end;

    procedure GetRandomDate(StartDate: Date; EndDate: Date): Date
    var
        DaysDifference: Integer;
        RandomDays: Integer;
    begin
        if EndDate <= StartDate then
            exit(StartDate);

        DaysDifference := EndDate - StartDate;
        RandomDays := GetRandomInteger(0, DaysDifference);

        exit(StartDate + RandomDays);
    end;

    procedure GetRandomBoolean(): Boolean
    begin
        exit(GetRandomInteger(0, 1) = 1);
    end;

    local procedure InitializeLists()
    begin
        // Nombres de empresas
        CompanyNames.Add('Acme');
        CompanyNames.Add('Global Tech');
        CompanyNames.Add('Innovate');
        CompanyNames.Add('TechCorp');
        CompanyNames.Add('DataSoft');
        CompanyNames.Add('Summit');
        CompanyNames.Add('NextGen');
        CompanyNames.Add('ProActive');
        CompanyNames.Add('Alpha');
        CompanyNames.Add('Omega');
        CompanyNames.Add('Vertex');
        CompanyNames.Add('Nexus');
        CompanyNames.Add('Quantum');
        CompanyNames.Add('Prime');
        CompanyNames.Add('Elite');
        CompanyNames.Add('Stellar');
        CompanyNames.Add('Fusion');
        CompanyNames.Add('Synergy');
        CompanyNames.Add('Momentum');
        CompanyNames.Add('Vanguard');

        // Nombres propios
        FirstNames.Add('Juan');
        FirstNames.Add('María');
        FirstNames.Add('Carlos');
        FirstNames.Add('Ana');
        FirstNames.Add('Pedro');
        FirstNames.Add('Laura');
        FirstNames.Add('Miguel');
        FirstNames.Add('Sofia');
        FirstNames.Add('David');
        FirstNames.Add('Carmen');
        FirstNames.Add('José');
        FirstNames.Add('Isabel');
        FirstNames.Add('Antonio');
        FirstNames.Add('Elena');
        FirstNames.Add('Francisco');

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
        LastNames.Add('Jiménez');
        LastNames.Add('Ruiz');
        LastNames.Add('Hernández');
        LastNames.Add('Díaz');
        LastNames.Add('Moreno');

        // Calles
        Streets.Add('Calle Mayor');
        Streets.Add('Avenida Principal');
        Streets.Add('Calle del Sol');
        Streets.Add('Plaza de España');
        Streets.Add('Calle Real');
        Streets.Add('Avenida de la Constitución');
        Streets.Add('Calle Gran Vía');
        Streets.Add('Paseo de la Castellana');
        Streets.Add('Calle Serrano');
        Streets.Add('Avenida Diagonal');
        Streets.Add('Calle Alcalá');
        Streets.Add('Ronda de Toledo');
        Streets.Add('Calle Bravo Murillo');
        Streets.Add('Avenida América');
        Streets.Add('Calle Goya');

        // Ciudades
        Cities.Add('Madrid');
        Cities.Add('Barcelona');
        Cities.Add('Valencia');
        Cities.Add('Sevilla');
        Cities.Add('Zaragoza');
        Cities.Add('Málaga');
        Cities.Add('Murcia');
        Cities.Add('Palma');
        Cities.Add('Bilbao');
        Cities.Add('Alicante');
        Cities.Add('Córdoba');
        Cities.Add('Valladolid');
        Cities.Add('Vigo');
        Cities.Add('Gijón');
        Cities.Add('Granada');

        // Prefijos de productos
        ItemPrefixes.Add('Premium');
        ItemPrefixes.Add('Deluxe');
        ItemPrefixes.Add('Standard');
        ItemPrefixes.Add('Professional');
        ItemPrefixes.Add('Basic');
        ItemPrefixes.Add('Advanced');
        ItemPrefixes.Add('Classic');
        ItemPrefixes.Add('Modern');
        ItemPrefixes.Add('Elite');
        ItemPrefixes.Add('Essential');

        // Categorías de productos
        ItemCategories.Add('Widget');
        ItemCategories.Add('Component');
        ItemCategories.Add('Module');
        ItemCategories.Add('Assembly');
        ItemCategories.Add('Part');
        ItemCategories.Add('Tool');
        ItemCategories.Add('Device');
        ItemCategories.Add('Equipment');
        ItemCategories.Add('Accessory');
        ItemCategories.Add('Supply');
        ItemCategories.Add('Material');
        ItemCategories.Add('Unit');
        ItemCategories.Add('System');
        ItemCategories.Add('Product');
        ItemCategories.Add('Item');
    end;
}
