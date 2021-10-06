tableextension 50100 StockedAttributeItem extends Item
{
    fields
    {
        field(50100; StockedAttributeTemplateCode; Code[20])
        {
            Caption = 'Stocked Attribute Template Code';
            DataClassification = CustomerContent;
            TableRelation = StockedAttributeTemplate.Code;
        }
        field(50101; StockedAttributeEntryPageType; Enum StockedAttributeEntryPageType)
        {
            Caption = 'Entry Page Type';
            DataClassification = CustomerContent;
            InitValue = Default;
        }

        field(50102; StockedAttributeSearchText; Text[2048])
        {
            Caption = 'Search Text1';
            DataClassification = CustomerContent;
        }

        field(50103; StockedAttributeSearchText2; Text[2048])
        {
            Caption = 'Search Text2';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Search; StockedAttributeSearchText, StockedAttributeSearchText2) { }
    }
}