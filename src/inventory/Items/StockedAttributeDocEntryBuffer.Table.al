table 50105 StockedAttributeDocEntryBuffer
{
    Caption = 'Stocked Attribute Entry Buffer';
    DataClassification = SystemMetadata;
    Extensible = true;
    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Variant Code"; Code[20])
        {
            Caption = 'Variant Code';
            DataClassification = SystemMetadata;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup (Item.Description where("No." = field("Item No.")));
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(6; UnitofMeasureCode; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = SystemMetadata;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(7; LocationCode; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = SystemMetadata;
            TableRelation = Location;
        }

        field(8; "Attribute Filter 1"; Integer)
        {
            Caption = 'Attribute Filter 1';
        }
        field(9; "Attribute Filter 2"; Integer)
        {
            Caption = 'Attribute Filter 2';
        }
        field(10; "Attribute Filter 3"; Integer)
        {
            Caption = 'Attribute Filter 3';
        }
        field(11; "Attribute Filter 4"; Integer)
        {
            Caption = 'Attribute Filter 4';
        }
        field(12; "Attribute Filter 5"; Integer)
        {
            Caption = 'Attribute Filter 5';

        }
        field(13; "Attribute Filter 6"; Integer)
        {
            Caption = 'Attribute Filter 6';

        }
        field(14; "Attribute Filter 7"; Integer)
        {
            Caption = 'Attribute Filter 7';

        }
        field(15; "Attribute Filter 8"; Integer)
        {
            Caption = 'Attribute Filter 8';

        }
        field(16; "Attribute Filter 9"; Integer)
        {
            Caption = 'Attribute Filter 9';

        }
        field(17; "Attribute Filter 10"; Integer)
        {
            Caption = 'Attribute Filter 10';

        }
        field(18; "Attribute Filter 11"; Integer)
        {
            Caption = 'Attribute Filter 11';

        }
        field(19; "Attribute Filter 12"; Integer)
        {
            Caption = 'Attribute Filter 12';

        }
        field(20; "Attribute Filter 13"; Integer)
        {
            Caption = 'Attribute Filter 13';

        }
        field(21; "Attribute Filter 14"; Integer)
        {
            Caption = 'Attribute Filter 14';

        }
        field(22; "Attribute Filter 15"; Integer)
        {
            Caption = 'Attribute Filter 15';

        }
        field(23; "Attribute Filter 16"; Integer)
        {
            Caption = 'Attribute Filter 16';

        }
        field(24; "Attribute Filter 17"; Integer)
        {
            Caption = 'Attribute Filter 17';

        }
        field(25; "Attribute Filter 18"; Integer)
        {
            Caption = 'Attribute Filter 18';

        }
        field(26; "Attribute Filter 19"; Integer)
        {
            Caption = 'Attribute Filter 19';

        }
        field(27; "Attribute Filter 20"; Integer)
        {
            Caption = 'Attribute Filter 20';

        }
        field(28; "Template Filter"; Integer)
        {
            Caption = 'Attribute Template Filter';
            DataClassification = SystemMetadata;
        }
        field(29; PageSelections; Text[2048])
        {
            Caption = 'Page Selections';
            DataClassification = SystemMetadata;
        }
        field(30; AttributeSetId; Integer)
        {
            Caption = 'Attribute Set Id';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }

}
