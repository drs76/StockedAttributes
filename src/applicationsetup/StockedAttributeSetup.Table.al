table 50100 StockedAttributeSetup
{
    Caption = 'StockedAttributesSetup';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = SystemMetadata;
        }
        field(3; EntryPageType; Enum StockedAttributeEntryPageType)
        {
            Caption = 'Entry Page Type';
            DataClassification = SystemMetadata;
            InitValue = None;

            trigger OnValidate()
            var
                DefaultErr: Label 'Cannot select default for the default';
            begin
                if EntryPageType = EntryPageType::Default then
                    Error(DefaultErr);
            end;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
