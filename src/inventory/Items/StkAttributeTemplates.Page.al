/// <summary>
/// PagePTEStkAttributeTemplates (ID 50106).
/// </summary>
page 50106 PTEStkAttributeTemplates
{

    Caption = 'Stocked Attribute Templates';
    PageType = List;
    SourceTable = PTEStkAttributeTemplate;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = PTEStkAttributeTemplate;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Stocked Attribute Template Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Stocked Attribute Template Description';
                }
                field(EntryPageType; Rec.EntryPageType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Stocked Attribute Template Entry Page Type';
                }
            }
        }
    }

}
