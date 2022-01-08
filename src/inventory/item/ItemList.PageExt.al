/// <summary>
/// PageExtension PTEItemList (ID 50104) extends Record Item List.
/// </summary>
pageextension 50104 PTEItemList extends "Item List"
{
    layout
    {
        modify(ItemAttributesFactBox)
        {
            Visible = not StkAttributeVisible;
        }
    }

    actions
    {
        addfirst(processing)
        {
            action(PTEFastSearch)
            {
                ApplicationArea = All;
                Image = Find;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = StkAttributeVisible;
                ToolTip = 'Find Items using attribute values.';

                trigger OnAction()
                begin
                    DoSearch();
                end;
            }
        }

        modify(Attributes)
        {
            Visible = not StkAttributeVisible;
        }

        modify(ClearAttributes)
        {
            Visible = not StkAttributeVisible;
        }

        modify(FilterByAttributes)
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

    /// <summary>
    /// DoSearch
    /// </summary>
    local procedure DoSearch()
    begin
        Codeunit.Run(Codeunit::SearchManagement);
    end;
}
