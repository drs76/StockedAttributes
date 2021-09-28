/// <summary>
/// PageExtension StockedAttributeItemCard (ID 50102) extends Record Item Card.
/// </summary>
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
                field(StockedAttributeTemplateCode; Rec.StockedAttributeTemplateCode)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Select the stocked attribute template to use for this item';
                }
                field(StockedAttributeEntryPageType; Rec.StockedAttributeEntryPageType)
                {
                    ToolTip = 'Default: Stocked Attribute Template, Configurator: Configurator Entry Page, Quick Entry: Quick Entry Page, None: BC Standard';
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