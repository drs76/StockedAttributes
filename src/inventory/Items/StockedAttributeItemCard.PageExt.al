pageextension 50102 StockedAttributeItemCard extends "Item Card"
{
    layout
    {
        addbefore(Inventory)
        {
            field(StockedAttributeTemplateID; StockedAttributeTemplateCode)
            {
                ToolTip = 'Stocked Attribute Template Code';
                Visible = StockedAttributeVisible;
                ApplicationArea = All;
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