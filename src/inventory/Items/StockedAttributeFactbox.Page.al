page 50102 StockedAttributeFactbox
{
    Caption = 'Stocked Attributes';
    PageType = ListPart;
    Editable = false;
    SourceTable = StockedAttributeSetEntry;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Repeater1)
            {
                field("Attribute Code"; "Attribute Code")
                {
                    Width = 20;
                    ApplicationArea = All;
                }
                field("Attribute Value"; "Attribute Value")
                {
                    Caption = 'Value';
                    ApplicationArea = All;
                }
            }
        }
    }
}
