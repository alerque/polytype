+++
title = "Samples"
paginate_by = 5
sort_by = "none"
+++

{% set samples = load_data(path="/data/samples.toml") -%}
{% for sample in samples["sample"] %}

### {{ sample.title }}
{{ sample.description }}

{% for typesetter in sample.typesetters %}
*	{{ typesetter }} (<a href="{{ sample.id }}-{{ typesetter }}.pdf">pdf</a>)<br />
	{% set raw = load_data(path="/samples/" ~ sample.id ~ "/sile.sil") %}
	<pre>{{ raw | safe }}</pre>
{% endfor %}
{% endfor %}
