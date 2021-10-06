/// <summary>
/// PageExtension StockedAttributeItemList (ID 50104) extends Record Item List.
/// </summary>
pageextension 50104 StockedAttributeItemList extends "Item List"
{
    actions
    {
        addfirst(processing)
        {
            action(FastSearch)
            {
                ApplicationArea = All;
                Image = Find;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //run search
                    RunSearch();
                end;
            }
        }
    }

    /// <summary>
    /// RunSearch.
    /// </summary>
    local procedure RunSearch()
    begin
        Page.Run(Page::StockedAttributeItemSearch);
    end;
}
