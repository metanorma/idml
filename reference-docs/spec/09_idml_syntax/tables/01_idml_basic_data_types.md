# Table 1. IDML basic data types

| Script Data Type     | Schema Data Type     | Value of Type Attribute in an IDML File |
| -------------------- | -------------------- | ------------------------------------------------------------------------ |
| boolean              | xsd:boolean          | boolean |
| string               | xsd:string           | string |
| short integer        | xsd:short            | short |
| long integer         | xsd:int              | long |
| longlong integer     | xsd:int              | longlong |
| double               | xsd:double           | double |
| object               | xsd:string           | object |
| object list          | xsd:string           | list of strings as a space­separated string |
| list                 | xsd:string           | list of simple types as a space­separated string |
| date                 | xsd:date             | date |
| file                 | xsd:string           | file |
| enumeration          | xsd:string           | Depends on the definition of the enumeration specified in datatype.rnc |
| unit                 | xsd:double           | unit or double |
| record               | text                 | record |
| stream               | text                 | binary |

