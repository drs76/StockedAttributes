pageextension 50100 StockedAttributeItemAttribute extends "Item Attribute"
{
    layout
    {
        addafter(Blocked)
        {
            field(StockedAttribute; StockedAttribute)
            {
                ToolTip = 'This attribute can be used for stocked attribute variants';
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