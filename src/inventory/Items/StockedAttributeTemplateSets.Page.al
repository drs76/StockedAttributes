/// <summary>
/// Page StockedAttributeTemplateSets (ID 50103).
/// </summary>
page 50103 StockedAttributeTemplateSets
{
    Caption = 'Stocked Attribute Template Sets';
    LinksAllowed = false;
    PageType = List;
    SourceTable = StockedAttributeTemplateEntry;
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
                field("Attribute Code"; Rec."Attribute Code")
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
                field("Attribute Value"; Rec."Attribute Value")
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
                    StockedAttributeMgmt.CopyAttributesToTemplate(Rec);
                    currPage.Update(false);
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        StockedAttributeTemplate."Template Set ID" := StockedAttributeMgmt.GetAttributeTemplateSetID(Rec);
        StockedAttributeTemplate.Modify();
    end;

    trigger OnOpenPage()
    begin
        NewTemplateID := GetRangeMin(TemplateID);
        StockedAttributeMgmt.GetAttributeTemplateSet(Rec, NewTemplateID);
    end;

    /// <summary>
    /// SetTemplate.
    /// </summary>
    /// <param name="TemplateIn">Record StockedAttributeTemplate.</param>
    procedure SetTemplate(TemplateIn: Record StockedAttributeTemplate)
    begin
        StockedAttributeTemplate.Copy(TemplateIn);
    end;

    var
        StockedAttributeTemplate: Record StockedAttributeTemplate;
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        NewTemplateID: Integer;
}