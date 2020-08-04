page 50105 StockedAttributeTemplate
{

    Caption = 'Stocked Attribute Template';
    PageType = Card;
    SourceTable = StockedAttributeTemplate;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            Action(EditAttributes)
            {
                Caption = 'Attributes';
                ToolTip = 'Edit attributes for this template';
                ApplicationArea = All;
                Image = DimensionSets;

                trigger OnAction()
                var
                    StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
                begin
                    StockedAttributeMgmt.EditStockedAttributeTemplate(Rec);
                end;
            }
        }
    }

}
