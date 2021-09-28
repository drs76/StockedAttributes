/// <summary>
/// PageExtension StockedAttributeItemAttribute (ID 50100) extends Record Item Attribute.
/// </summary>
pageextension 50100 StockedAttributeItemAttribute extends "Item Attribute"
{
    layout
    {
        addlast(content)
        {
            group(StockedAttributeGrp)
            {
                Caption = 'Stocked Attribute';
                Visible = StockedAttributeVisible;

                field(StockedAttribute; Rec.StockedAttribute)
                {
                    ToolTip = 'This attribute can be used for stocked attribute variants';
                    ApplicationArea = All;
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