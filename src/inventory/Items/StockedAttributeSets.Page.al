page 50101 StockedAttributeSets
{
    Caption = 'Stocked Attributes Sets';
    LinksAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = StockedAttributeSetEntry;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Attributes)
            {
                field(AttributeSetID; AttributeSetID)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Attribute Code"; "Attribute Code")
                {
                    Caption = 'Attribute';
                    ToolTip = 'Attribute Code';
                    ApplicationArea = All;
                }
                field("Attribute Value"; "Attribute Value")
                {
                    Caption = 'Attribute Value';
                    ToolTip = 'Attribute Value';
                    ApplicationArea = All;
                }
            }
        }
    }
}