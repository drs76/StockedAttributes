/// <summary>
/// TableExtension PTEItem (ID 50100) extends Record Item.
/// </summary>
tableextension 50100 PTEItem extends Item
{
    fields
    {
        field(50100; PTEStkAttributeTemplateCode; Code[20])
        {
            Caption = 'Stocked Attribute Template Code';
            DataClassification = CustomerContent;
            TableRelation = PTEStkAttributeTemplate.TemplateCode;
        }
        field(50101; PTEStkAttributeEntryPageType; Enum PTEStkAttributeEntryPageType)
        {
            Caption = 'Entry Page Type';
            DataClassification = CustomerContent;
            InitValue = Default;
        }

        field(50102; PTEStkAttributeSearchText; Text[2048])
        {
            Caption = 'Search Text1';
            DataClassification = CustomerContent;
        }

        field(50103; PTEStkAttributeSearchText2; Text[2048])
        {
            Caption = 'Search Text2';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Search; PTEStkAttributeSearchText, PTEStkAttributeSearchText2) { }
    }
}