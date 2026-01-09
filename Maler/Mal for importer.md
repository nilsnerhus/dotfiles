---
tags:{% for t in tags %}
- {{t.tag | replace(r/\s+/g, "-")}}{% endfor %}
- kilde
- zotero
---
# {{title | replace('"',"'")}}

*Importert fra Zotero {{importDate | format("DD-MMM-YYYY")}}*
{% persist "notes" -%}
{%- if isFirstImport %}
## Hovedpoenger


{% endif %}{% endpersist %}

> [!info]- Info
> **Forfatter**: {% for a in creators %} [[2 Notater/Personnotater/{{a.firstName}} {{a.lastName}}|{{a.firstName}} {{a.lastName}}]]{% if not loop.last %}, {% endif %}{% endfor %}

> [!abstract]- Sammendrag
> {% if abstractNote %}
> {{abstractNote|replace("\n","\n>")|striptags(true)|replace("Objectives", "**Objectives**")|replace("Background", "**Background**")|replace("Methodology", "**Methodology**")|replace("Results","**Results**")|replace("Conclusion","**Conclusion**")}}
> {% endif %}

> [!quote]- Referanser
> 
> ```query
> content: "@{{citekey}}" -file:@{{citekey}}
> ```

## Sitater
{% set colorValueMap = {
    "#2ea8e5": {
        "colorCategory": "Blue",
        "heading": "❓ Sak",
        "symbol": "?"
    },
    "#5fb236": {
        "colorCategory": "Green",
        "heading": "🎯 Forskningsdesign",
        "symbol": "$"
    },
    "#ffd400": {
        "colorCategory": "Yellow",
        "heading": "💬 Analyse",
        "symbol": "&"
    },
    "#f19837": {
        "colorCategory": "Orange",
        "heading": "✅ Konklusjon",
        "symbol": "!"
    }
} -%}
{%- macro tagFormatter(annotation) -%}
    {% if annotation.tags -%}
        {%- for t in annotation.tags %} #{{ t.tag | replace(r/\s+/g, "-") }}{% if not loop.last %}, {% endif %}{%- endfor %}
    {%- endif %}
{%- endmacro -%}
{% persist "annotations" %}
{% set annotations = annotations | filterby("date", "dateafter", lastImportDate) -%}
{% if annotations.length > 0 %}

{%- set grouped_annotations = annotations | groupby("color") -%}
{%- for color, colorValue in colorValueMap -%}
{%- if color in grouped_annotations -%} 
{%- set annotations = grouped_annotations[color] -%}
{%- for annotation in annotations -%}
{%- set citationLink = '[(p. ' ~ annotation.pageLabel ~ ')](' ~ annotation.desktopURI ~ ')' %}
{%- set tagString = tagFormatter(annotation) %}

{%- if annotation and loop.first %}
### {{colorValue.heading}}
{% endif -%}

{%- if annotation.imageRelativePath %}

> [!cite]+ Image {{citationLink}}
> ![[{{annotation.imageRelativePath}}]]{% if annotation.tags %}
> {{tagString}}{% endif %}{%- if (annotation.comment or []).indexOf("todo ") !== -1 %}
> - [ ] **{{annotation.comment | replace("todo ", "")}}**{%- elif annotation.comment %}
> **{{annotation.comment}}**{%- endif %}
{% elif (annotation.comment or []).indexOf("todo ") !== -1 %}
- [ ] **{{annotation.comment | replace("todo ", "")}}**:{% if not annotation.annotatedText %} {{citationLink}}{% else %}
	- {{colorValue.symbol}}  {{annotation.annotatedText | replace(r/\s+/g, " ")}} {{citationLink}}{{tagString}}{% endif -%}
{% elif annotation.comment %}
- **{{annotation.comment}}**:{% if not annotation.annotatedText %} {{citationLink}}{% else %}
	- {{colorValue.symbol}}  {{annotation.annotatedText | replace(r/\s+/g, " ") }} {{citationLink}}{{tagString}}{% endif -%}
{%- elif annotation.annotatedText %}
- {{colorValue.symbol}}  {{annotation.annotatedText | replace(r/\s+/g, " ") }} {{citationLink}}{{tagString}}
{%- endif -%}{%- endfor %}{%- endif -%}
{% endfor -%}
{% endif %}

{% endpersist %}