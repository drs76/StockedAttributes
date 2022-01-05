/// <summary>
/// PagePTEStkAttributeTemplate (ID 50105).
/// </summary>
page 50105 PTEStkAttributeTemplate
{

    Caption = 'Stocked Attribute Template';
    PageType = Card;
    SourceTable = PTEStkAttributeTemplate;
    UsageCategory = None;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Specifies the Stocked Attribute Template Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the Stocked Attribute Template Description';
                }
                field("Template Set ID"; Rec."Template Set ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Stocked Attribute Template Set ID';

                    trigger OnDrillDown()
                    var
                        PTEStkAttributeMgmt: Codeunit PTEStkAttributeMgmt;
                    begin
                        PTEStkAttributeMgmt.EditStockedAttributeTemplate(Rec);
                    end;
                }
                field(EntryPageType; Rec.EntryPageType)
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
                        PTEStkAttributeMgmt: Codeunit PTEStkAttributeMgmt;
                    begin
                        PTEStkAttributeMgmt.EditStockedAttributeTemplate(Rec);
                    end;
                }
            }
        }
    }

}
