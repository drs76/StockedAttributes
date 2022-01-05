/// <summary>
/// PageExtension PTEStkItemAttributes (ID 50101) extends Page Item Attributes.
/// </summary>
pageextension 50101 PTEStkItemAttributes extends "Item Attributes"
{
    layout
    {
        addafter(Blocked)
        {
            field(PTEStockedAttribute; Rec.PTEStkAttribute)
            {
                Caption = 'Stocked Attribute';
                Visible = StkAttributeVisible;
                ToolTip = 'Attribute is used for stocked attribute inventory';
                Importance = Promoted;
                ApplicationArea = All;
            }
        }
    }

    trigger OnOpenPage()
    begin
        StkAttributeVisible := StkAttributeMgmt.IsEnabled();
    end;

    var
        StkAttributeMgmt: Codeunit PTEStkAttributeMgmt;
        StkAttributeVisible: Boolean;
}