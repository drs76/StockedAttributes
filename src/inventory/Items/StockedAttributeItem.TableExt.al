tableextension 50100 StockedAttributeItem extends Item
{
    fields
    {
        field(50100; StockedAttributeTemplateID; Integer)
        {
            Caption = 'Stocked Attribute Template';
            DataClassification = SystemMetadata;
        }
        field(50101; StockedAttributeLineID; Integer)
        {
            Caption = 'Stocked Attribute Line ID';
            DataClassification = SystemMetadata;
        }
        field(50102; StockedAttributeColumnID; Integer)
        {
            Caption = 'Stocked Attribute Column ID';
            DataClassification = SystemMetadata;
        }
    }
}