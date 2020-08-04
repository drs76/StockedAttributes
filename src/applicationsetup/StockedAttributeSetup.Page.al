page 50100 StockedAttributeSetup
{

    PageType = Card;
    SourceTable = StockedAttributeSetup;
    Caption = 'Stocked Attribute Setup';
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Enabled; Enabled)
                {
                    Caption = 'Enabled';
                    ToolTip = 'Enable or disable the stocked attribute functionality';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(StockedAttributes)
            {
                Caption = 'Templates';
                ToolTip = 'Setup stocked attribute template''s';
                ApplicationArea = All;
                Image = DimensionSets;
                RunObject = Page StockedAttributeTemplates;
            }
        }
    }
}