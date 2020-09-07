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
                    Style = Strong;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Template Set ID"; "Template Set ID")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
                    begin
                        StockedAttributeMgmt.EditStockedAttributeTemplate(Rec);
                    end;
                }
                field(EntryPageType; EntryPageType)
                {
                    ToolTip = 'Default: Stocked Attribute Setup, Configurator: Configurator Entry Page, Quick Entry: Quick Entry Page, None: BC Standard';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(StockedAttributes)
            {
                Action(EditAttributes)
                {
                    Caption = 'Attributes';
                    ToolTip = 'Edit attributes for this template';
                    ApplicationArea = All;
                    Image = DimensionSets;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

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

}
