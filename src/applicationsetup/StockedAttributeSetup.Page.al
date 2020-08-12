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
            action(ItemAttributes)
            {
                Caption = 'Attributes';
                ToolTip = 'Item Attribute''s';
                ApplicationArea = All;
                Image = DimensionSets;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Attributes";
            }
            action(StockedAttributes)
            {
                Caption = 'Templates';
                ToolTip = 'Setup stocked attribute template''s';
                ApplicationArea = All;
                Image = DimensionSets;
                PromotedOnly = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page StockedAttributeTemplates;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not FindFirst() then begin
            Init();
            Insert();
        end;
    end;
}