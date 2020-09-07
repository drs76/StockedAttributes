pageextension 50101 StockedAttributeItemAttributes extends "Item Attributes"
{
    layout
    {
        addafter(Blocked)
        {
            field(StockedAttribute; StockedAttribute)
            {
                Caption = 'Stocked Attribute';
                Visible = StockedAttributeVisible;
                ToolTip = 'Attribute is used for stocked attribute inventory';
                Importance = Promoted;
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