/// <summary>
/// PageExtension PTEItemList (ID 50104) extends Record Item List.
/// </summary>
pageextension 50104 PTEItemList extends "Item List"
{
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
        Codeunit.Run(Codeunit::SearchManagement);
        //Page.Run(Page::StockedAttributeItemSearch);
    end;
}
