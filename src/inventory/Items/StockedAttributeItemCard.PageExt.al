pageextension 50102 StockedAttributeItemCard extends "Item Card"
{
    layout
    {
        addlast(content)
        {
            group(StockedAttributeGrp)
            {
                Caption = 'Stocked Attribute';
                Visible = StockedAttributeVisible;

                field(StockedAttributeTemplateCode; StockedAttributeTemplateCode)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Select the stocked attribute template to use for this item';
                }
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