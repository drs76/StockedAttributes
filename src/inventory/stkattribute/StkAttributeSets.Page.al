/// <summary>
/// PagePTEStkAttributeSets (ID 50101).
/// </summary>
page 50101 PTEStkAttributeSets
{
    Caption = 'Stocked Attributes Sets';
    LinksAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = PTEStkAttributeSetEntry;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Attributes)
            {
                field(AttributeSetID; Rec.AttributeSetID)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec.AttributeCode)
                {
                    Caption = 'Attribute';
                    ToolTip = 'Attribute Code';
                    ApplicationArea = All;
                }
                field("Attribute Value"; Rec.AttributeValue)
                {
                    Caption = 'Attribute Value';
                    ToolTip = 'Attribute Value';
                    ApplicationArea = All;
                }
            }
        }
    }
}