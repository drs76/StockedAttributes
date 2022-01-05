/// <summary>
/// PagePTEStkAttributeFactbox (ID 50102).
/// </summary>
page 50102 PTEStkAttributeFactbox
{
    Caption = 'Stocked Attributes';
    PageType = ListPart;
    Editable = false;
    SourceTable = PTEStkAttributeSetEntry;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Repeater1)
            {
                field("Attribute Code"; Rec."Attribute Code")
                {
                    Width = 20;
                    ApplicationArea = All;
                }
                field("Attribute Value"; Rec."Attribute Value")
                {
                    Caption = 'Value';
                    ApplicationArea = All;
                }
            }
        }
    }
}
