/// <summary>
/// Enum StockedAttributeEntryPageType (ID 50100).
/// </summary>
enum 50100 StockedAttributeEntryPageType
{
    Extensible = true;

    value(0; None)
    {
        Caption = 'None';
    }

    value(1; Default)
    {
        Caption = 'Default';
    }
    value(2; Configurator)
    {
        Caption = 'Configurator';
    }
    value(3; "Quick Entry")
    {
        Caption = 'Quick Entry';
    }

    value(4; "Search Entry")
    {
        Caption = 'Search Entry';
    }
}
