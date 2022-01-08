/// <summary>
/// PageExtension PTEItemAttribute (ID 50100) extends Page Item Attribute.
/// </summary>
pageextension 50100 PTEItemAttribute extends "Item Attribute"
{
    layout
    {
        addlast(content)
        {
            group(PTEStockedAttributeGrp)
            {
                Caption = 'Stocked Attribute';
                Visible = StkAttributeVisible;

                field(PTEStkAttribute; Rec.PTEStkAttribute)
                {
                    ToolTip = 'This attribute can be used for stocked attribute variants';
                    ApplicationArea = All;
                }
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