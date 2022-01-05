/// <summary>
/// PagePTEStkAttributeTemplateSets (ID 50103).
/// </summary>
page 50103 PTEStkAttributeTemplateSets
{
    Caption = 'Stocked Attribute Template Sets';
    LinksAllowed = false;
    PageType = List;
    SourceTable = PTEStkAttributeTemplateEntry;
    SourceTableTemporary = true;
    DelayedInsert = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Repeater1)
            {
                field(AttributeID; Rec.AttributeID)
                {
                    Caption = 'Attribute ID';
                    Editable = AttributeValueID = 0;
                    ToolTip = 'Specifies the attribute.';
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Attribute Code"; Rec.AttributeCode)
                {
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the descriptive name of the Attribute.';
                    Enabled = false;
                    ApplicationArea = All;
                }
                field(AttributeValueID; Rec.AttributeValueID)
                {
                    Caption = 'Value ID';
                    ToolTip = 'Specifies the attribute value.';
                    Width = 10;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        currPage.Update();
                    end;
                }
                field("Attribute Value"; Rec.AttributeValue)
                {
                    Caption = 'Value';
                    ToolTip = 'Specifies the descriptive name of the Attribute Value.';
                    Enabled = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AddAttributes)
            {
                Caption = 'Copy';
                ApplicationArea = All;
                Image = Copy;
                ToolTip = 'Copy item attribute and values to the template';

                trigger OnAction()
                begin
                    PTEStkAttributeMgmt.CopyAttributesToTemplate(Rec);
                    currPage.Update(false);
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        PTEStkAttributeTemplate.TemplateSetId := PTEStkAttributeMgmt.GetAttributeTemplateSetID(Rec);
        PTEStkAttributeTemplate.Modify();
    end;

    trigger OnOpenPage()
    begin
        NewTemplateID := GetRangeMin(TemplateID);
        PTEStkAttributeMgmt.GetAttributeTemplateSet(Rec, NewTemplateID);
    end;

    /// <summary>
    /// SetTemplate.
    /// </summary>
    /// <param name="TemplateIn">Record PTEStkAttributeTemplate.</param>
    procedure SetTemplate(TemplateIn: Record PTEStkAttributeTemplate)
    begin
        PTEStkAttributeTemplate.Copy(TemplateIn);
    end;

    var
        PTEStkAttributeTemplate: Record PTEStkAttributeTemplate;
        PTEStkAttributeMgmt: Codeunit PTEStkAttributeMgmt;
        NewTemplateID: Integer;
}