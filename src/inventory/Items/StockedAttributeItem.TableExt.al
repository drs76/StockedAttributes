tableextension 50100 StockedAttributeItem extends Item
{
    fields
    {
        field(50100; StockedAttributeTemplateCode; Code[20])
        {
            Caption = 'Stocked Attribute Template Code';
            DataClassification = SystemMetadata;
            TableRelation = StockedAttributeTemplate.Code;
        }
    }
}