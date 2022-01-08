/// <summary>
/// PageExtension PTEItemCard (ID 50102) extends Page Item Card.
/// </summary>
pageextension 50102 PTEItemCard extends "Item Card"
{
    layout
    {
        addlast(content)
        {
            group(PTEStockedAttributeGrp)
            {
                Caption = 'Stocked Attribute';
                Visible = StkAttributeVisible;

                field(PTEStkAttributeTemplateCode; Rec.PTEStkAttributeTemplateCode)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Select the stocked attribute template to use for this item';
                }

                field(PTEStkAttributeEntryPageType; Rec.PTEStkAttributeEntryPageType)
                {
                    ToolTip = 'Default: Stocked Attribute Template, Configurator: Configurator Entry Page, Quick Entry: Quick Entry Page, None: BC Standard';
                    ApplicationArea = All;
                }
            }
        }

        // addfirst(FactBoxes)
        // {
        //     part(StockedAttributesFactBox; PTEStkAttributeFactbox)
        //     {
        //         ApplicationArea = All;
        //         SubPageLink = AttributeSetID = field(PTEStkAttributeSetId);
        //     }
        // }

        modify(ItemAttributesFactbox)
        {
            Visible = not StkAttributeVisible;
        }
    }

    actions
    {
        modify("Va&riants")
        {
            ApplicationArea = All;
            Promoted = true;
            PromotedCategory = Category4;
        }

        modify(Attributes)
        {
            Visible = not StkAttributeVisible;
        }
    }

    trigger OnOpenPage()
    begin
        StkAttributeVisible := StkAttributeMgmt.IsEnabled();
    end;

    var
        StkAttributeMgmt: Codeunit PTEStkAttributeMgmt;
        [InDataSet]
        StkAttributeVisible: Boolean;

}