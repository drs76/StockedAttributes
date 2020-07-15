page 50103 StockedAttributeTemplates
{
    Caption = 'Stocked Attribute Template';
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
                field(AttributeID; AttributeID)
                {
                    Caption = 'Attribute ID';
                    Editable = AttributeValueID = 0;
                    ToolTip = 'Specifies the attribute.';
                    Width = 10;
                    ApplicationArea = All;
                }
                field("Attribute Code"; "Attribute Code")
                {
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the descriptive name of the Attribute.';
                    Enabled = false;
                    ApplicationArea = All;
                }
                field(AttributeValueID; AttributeValueID)
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
                field("Attribute Value"; "Attribute Value")
                {
                    Caption = 'Value';
                    ToolTip = 'Specifies the descriptive name of the Attribute Value.';
                    Enabled = false;
                    ApplicationArea = All;
                }
                field(YAxis; YAxis)
                {
                    Caption = 'Y Axis';
                    ToolTip = 'This attribute group will be used for the Y Axis on order entry grid';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetGridAxisFields(true);
                        currPage.Update();
                    end;
                }
                field(XAxis; XAxis)
                {
                    Caption = 'X Axis';
                    ToolTip = 'This attribute group will be used for the X Axis on order entry grid';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        SetGridAxisFields(false);
                        currPage.Update();
                    end;
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
                Caption = 'Copy attributes to template';
                ApplicationArea = All;
                Image = Action;
                ToolTip = 'Add item attributes and values to the template';

                trigger OnAction()
                begin
                    StockedAttributeMgmt.CopyAttributesToTemplate(Rec);
                    currPage.Update(false);
                end;
            }
            action(CreateAllPossibleVariants)
            {
                Caption = 'Create variants';
                ApplicationArea = All;
                Image = Action;
                ToolTip = 'Create item variants for all combinations of stocked attribute values';

                trigger OnAction()
                begin
                    StockedAttributeMgmt.CreateAllPossibleVariants(Item."No.", false);
                    currPage.Update(false);
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        Item.StockedAttributeTemplateID := StockedAttributeMgmt.GetAttributeTemplateSetID(Rec);
        Item.Modify(); // save changes made to the item fields.
    end;

    trigger OnOpenPage()
    begin
        NewTemplateID := GetRangeMin(TemplateID);
        StockedAttributeMgmt.GetAttributeTemplateSet(Rec, NewTemplateID);
    end;

    trigger OnAfterGetRecord()
    begin
        GetGridAxisFields();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetGridAxisFields();
    end;

    procedure SetItem(ItemIn: Record Item)
    begin
        Item.Copy(ItemIn);
    end;

    local procedure SetGridAxisFields(YAxis: Boolean)
    begin
        if AttributeID = 0 then
            exit;

        if YAxis then begin
            Item.StockedAttributeLineID := AttributeID;
            if Item.StockedAttributeColumnID = AttributeID then
                Item.StockedAttributeColumnID := 0;

            exit;
        end;

        Item.StockedAttributeColumnID := AttributeID;
        if Item.StockedAttributeLineID = AttributeID then
            Item.StockedAttributeLineID := 0;
    end;

    local procedure GetGridAxisFields()
    begin
        YAxis := Item.StockedAttributeLineID = AttributeID;
        XAxis := Item.StockedAttributeColumnID = AttributeID;
    end;

    var
        Item: Record Item;
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        NewTemplateID: Integer;
        XAxis: Boolean;
        YAxis: Boolean;
}