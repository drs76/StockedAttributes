page 50100 StockedAttributeSetup
{

    PageType = Card;
    SourceTable = StockedAttributeSetup;
    Caption = 'Stocked attribute setup';
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
}
