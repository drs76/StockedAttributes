pageextension 50102 StockedAttributeItemCard extends "Item Card"
{
    layout
    {
        addbefore(Inventory)
        {
            field(StockedAttributeTemplateID; StockedAttributeTemplateID)
            {
                ToolTip = 'Stocked Attribute Template Id';
                Visible = StockedAttributeVisible;
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Attributes)
        {
            action(StockedAttributes)
            {
                Caption = 'Stocked attribute template';
                Visible = StockedAttributeVisible;
                ApplicationArea = All;
                Image = DimensionSets;
                ToolTip = 'Setup a stocked attribute template to be used for this Item';
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    StockedAttributeMgmt.EditStockedAttributeTemplate(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        StockedAttributeVisible := StockedAttributeMgmt.IsEnabled();
    end;

    var
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        StockedAttributeVisible: Boolean;

}