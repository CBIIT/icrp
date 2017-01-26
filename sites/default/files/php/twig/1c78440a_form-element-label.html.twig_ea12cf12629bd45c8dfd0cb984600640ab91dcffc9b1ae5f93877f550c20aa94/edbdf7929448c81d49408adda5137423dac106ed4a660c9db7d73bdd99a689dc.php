<?php

/* themes/bootstrap/templates/input/form-element-label.html.twig */
class __TwigTemplate_9a51622e96f973f91d9775939b87ab1f2eb2365fdff1010066457d8f13d4389e extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $tags = array("set" => 22, "if" => 30);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('Twig_Extension_Sandbox')->checkSecurity(
                array('set', 'if'),
                array(),
                array()
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setSourceContext($this->getSourceContext());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 22
        $context["classes"] = array(0 => "control-label", 1 => (((        // line 24
($context["title_display"] ?? null) == "after")) ? ("option") : ("")), 2 => ((((        // line 25
($context["title_display"] ?? null) == "invisible") &&  !(($context["is_checkbox"] ?? null) || ($context["is_radio"] ?? null)))) ? ("sr-only") : ("")), 3 => ((        // line 26
($context["required"] ?? null)) ? ("js-form-required") : ("")), 4 => ((        // line 27
($context["required"] ?? null)) ? ("form-required") : ("")));
        // line 30
        if ((( !twig_test_empty(($context["title"] ?? null)) && (($context["title_display"] ?? null) == "invisible")) && (($context["is_checkbox"] ?? null) || ($context["is_radio"] ?? null)))) {
            // line 35
            $context["attributes"] = $this->getAttribute(($context["attributes"] ?? null), "setAttribute", array(0 => "title", 1 => ($context["title"] ?? null)), "method");
            // line 36
            $context["title"] = null;
        }
        // line 42
        if ((( !twig_test_empty(($context["title"] ?? null)) || ($context["is_checkbox"] ?? null)) || ($context["is_radio"] ?? null))) {
            // line 43
            echo "<label";
            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, $this->getAttribute(($context["attributes"] ?? null), "addClass", array(0 => ($context["classes"] ?? null)), "method"), "html", null, true));
            echo ">";
            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, ($context["element"] ?? null), "html", null, true));
            echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, ($context["title"] ?? null), "html", null, true));
            // line 44
            if (($context["description"] ?? null)) {
                // line 45
                echo "<p class=\"help-block\">";
                echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, ($context["description"] ?? null), "html", null, true));
                echo "</p>";
            }
            // line 47
            echo "</label>";
        }
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/input/form-element-label.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  71 => 47,  66 => 45,  64 => 44,  58 => 43,  56 => 42,  53 => 36,  51 => 35,  49 => 30,  47 => 27,  46 => 26,  45 => 25,  44 => 24,  43 => 22,);
    }

    /** @deprecated since 1.27 (to be removed in 2.0). Use getSourceContext() instead */
    public function getSource()
    {
        @trigger_error('The '.__METHOD__.' method is deprecated since version 1.27 and will be removed in 2.0. Use getSourceContext() instead.', E_USER_DEPRECATED);

        return $this->getSourceContext()->getCode();
    }

    public function getSourceContext()
    {
        return new Twig_Source("{#
/**
 * @file
 * Default theme implementation for a form element label.
 *
 * Available variables:
 * - element: an input element.
 * - title: The label's text.
 * - title_display: Elements title_display setting.
 * - description: element description.
 * - required: An indicator for whether the associated form element is required.
 * - is_checkbox: Whether the label is outputted in checkbox context.
 * - is_radio: Whether the label is outputted in radio button context.
 * - attributes: A list of HTML attributes for the label.
 *
 * @ingroup templates
 *
 * @see template_preprocess_form_element_label()
 */
#}
{%-
  set classes = [
    'control-label',
    title_display == 'after' ? 'option',
    title_display == 'invisible' and not (is_checkbox or is_radio) ? 'sr-only',
    required ? 'js-form-required',
    required ? 'form-required',
  ]
-%}
{% if title is not empty and title_display == 'invisible' and (is_checkbox or is_radio) -%}
  {#
  Clear but preserve label text as attribute (e.g. for screen readers) for
  checkboxes/radio buttons when it actually should be invisible.
  #}
  {%- set attributes = attributes.setAttribute('title', title) -%}
  {%- set title = null -%}
{%- endif -%}
{#
Labels for single checkboxes/radios contain the element itself and thus have
always to be rendered regardless of whether they have a title or not.
#}
{%- if title is not empty or is_checkbox or is_radio -%}
  <label{{ attributes.addClass(classes) }}>{{ element }}{{ title }}
    {%- if description -%}
      <p class=\"help-block\">{{ description }}</p>
    {%- endif -%}
  </label>
{%- endif -%}
", "themes/bootstrap/templates/input/form-element-label.html.twig", "/github/drupal8.dev/sites/icrp/themes/bootstrap/templates/input/form-element-label.html.twig");
    }
}
