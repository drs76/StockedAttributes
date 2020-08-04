page 50106 StockedAttributeTemplates
{

    Caption = 'Stocked Attribute Templates';
    PageType = List;
    SourceTable = StockedAttributeTemplate;
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = StockedAttributeTemplate;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
