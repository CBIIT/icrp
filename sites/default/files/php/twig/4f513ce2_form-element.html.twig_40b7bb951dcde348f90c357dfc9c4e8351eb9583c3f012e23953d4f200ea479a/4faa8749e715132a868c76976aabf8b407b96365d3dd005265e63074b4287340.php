<?php

/* themes/bootstrap/templates/input/form-element.html.twig */
class __TwigTemplate_27c6e8a8d6b7aeb26398b34a1cacff900de40e669b47bf149aedbf7ad333396c extends Twig_Template
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
        $tags = array("set" => 47, "if" => 70);
        $filters = array("clean_class" => 50);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('set', 'if'),
                array('clean_class'),
                array()
            );
        } catch (Twig_Sandbox_SecurityError $e) {
            $e->setTemplateFile($this->getTemplateName());

            if ($e instanceof Twig_Sandbox_SecurityNotAllowedTagError && isset($tags[$e->getTagName()])) {
                $e->setTemplateLine($tags[$e->getTagName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFilterError && isset($filters[$e->getFilterName()])) {
                $e->setTemplateLine($filters[$e->getFilterName()]);
            } elseif ($e instanceof Twig_Sandbox_SecurityNotAllowedFunctionError && isset($functions[$e->getFunctionName()])) {
                $e->setTemplateLine($functions[$e->getFunctionName()]);
            }

            throw $e;
        }

        // line 47
        $context["classes"] = array(0 => "form-item", 1 => "js-form-item", 2 => ("form-type-" . \Drupal\Component\Utility\Html::getClass(        // line 50
(isset($context["type"]) ? $context["type"] : null))), 3 => ("js-form-type-" . \Drupal\Component\Utility\Html::getClass(        // line 51
(isset($context["type"]) ? $context["type"] : null))), 4 => ("form-item-" . \Drupal\Component\Utility\Html::getClass(        // line 52
(isset($context["name"]) ? $context["name"] : null))), 5 => ("js-form-item-" . \Drupal\Component\Utility\Html::getClass(        // line 53
(isset($context["name"]) ? $context["name"] : null))), 6 => ((!twig_in_filter(        // line 54
(isset($context["title_display"]) ? $context["title_display"] : null), array(0 => "after", 1 => "before"))) ? ("form-no-label") : ("")), 7 => (((        // line 55
(isset($context["disabled"]) ? $context["disabled"] : null) == "disabled")) ? ("form-disabled") : ("")), 8 => ((        // line 56
(isset($context["is_form_group"]) ? $context["is_form_group"] : null)) ? ("form-group") : ("")), 9 => ((        // line 57
(isset($context["is_radio"]) ? $context["is_radio"] : null)) ? ("radio") : ("")), 10 => ((        // line 58
(isset($context["is_checkbox"]) ? $context["is_checkbox"] : null)) ? ("checkbox") : ("")), 11 => ((        // line 59
(isset($context["is_autocomplete"]) ? $context["is_autocomplete"] : null)) ? ("form-autocomplete") : ("")), 12 => ((        // line 60
(isset($context["errors"]) ? $context["errors"] : null)) ? ("error has-error") : ("")));
        // line 63
        $context["description_classes"] = array(0 => "description", 1 => "help-block", 2 => (((        // line 66
(isset($context["description_display"]) ? $context["description_display"] : null) == "invisible")) ? ("visually-hidden") : ("")));
        // line 69
        echo "<div";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["attributes"]) ? $context["attributes"] : null), "addClass", array(0 => (isset($context["classes"]) ? $context["classes"] : null)), "method"), "html", null, true));
        echo ">
  ";
        // line 70
        if (twig_in_filter((isset($context["label_display"]) ? $context["label_display"] : null), array(0 => "before", 1 => "invisible"))) {
            // line 71
            echo "    ";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
            echo "
  ";
        }
        // line 73
        echo "
  ";
        // line 74
        if ((((isset($context["description_display"]) ? $context["description_display"] : null) == "before") && $this->getAttribute((isset($context["description"]) ? $context["description"] : null), "content", array()))) {
            // line 75
            echo "    <div";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["description"]) ? $context["description"] : null), "attributes", array()), "html", null, true));
            echo ">
      ";
            // line 76
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["description"]) ? $context["description"] : null), "content", array()), "html", null, true));
            echo "
    </div>
  ";
        }
        // line 79
        echo "
  ";
        // line 80
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["children"]) ? $context["children"] : null), "html", null, true));
        echo "

  ";
        // line 82
        if (((isset($context["label_display"]) ? $context["label_display"] : null) == "after")) {
            // line 83
            echo "    ";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["label"]) ? $context["label"] : null), "html", null, true));
            echo "
  ";
        }
        // line 85
        echo "
  ";
        // line 86
        if ((twig_in_filter((isset($context["description_display"]) ? $context["description_display"] : null), array(0 => "after", 1 => "invisible")) && $this->getAttribute((isset($context["description"]) ? $context["description"] : null), "content", array()))) {
            // line 87
            echo "    <div";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute($this->getAttribute((isset($context["description"]) ? $context["description"] : null), "attributes", array()), "addClass", array(0 => (isset($context["description_classes"]) ? $context["description_classes"] : null)), "method"), "html", null, true));
            echo ">
      ";
            // line 88
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["description"]) ? $context["description"] : null), "content", array()), "html", null, true));
            echo "
    </div>
  ";
        }
        // line 91
        echo "</div>
";
    }

    public function getTemplateName()
    {
        return "themes/bootstrap/templates/input/form-element.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  120 => 91,  114 => 88,  109 => 87,  107 => 86,  104 => 85,  98 => 83,  96 => 82,  91 => 80,  88 => 79,  82 => 76,  77 => 75,  75 => 74,  72 => 73,  66 => 71,  64 => 70,  59 => 69,  57 => 66,  56 => 63,  54 => 60,  53 => 59,  52 => 58,  51 => 57,  50 => 56,  49 => 55,  48 => 54,  47 => 53,  46 => 52,  45 => 51,  44 => 50,  43 => 47,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a form element.*/
/*  **/
/*  * Available variables:*/
/*  * - attributes: HTML attributes for the containing element.*/
/*  * - required: The required marker, or empty if the associated form element is*/
/*  *   not required.*/
/*  * - type: The type of the element.*/
/*  * - name: The name of the element.*/
/*  * - label: A rendered label element.*/
/*  * - label_display: Label display setting. It can have these values:*/
/*  *   - before: The label is output before the element. This is the default.*/
/*  *     The label includes the #title and the required marker, if #required.*/
/*  *   - after: The label is output after the element. For example, this is used*/
/*  *     for radio and checkbox #type elements. If the #title is empty but the*/
/*  *     field is #required, the label will contain only the required marker.*/
/*  *   - invisible: Labels are critical for screen readers to enable them to*/
/*  *     properly navigate through forms but can be visually distracting. This*/
/*  *     property hides the label for everyone except screen readers.*/
/*  *   - attribute: Set the title attribute on the element to create a tooltip but*/
/*  *     output no label element. This is supported only for checkboxes and radios*/
/*  *     in \Drupal\Core\Render\Element\CompositeFormElementTrait::preRenderCompositeFormElement().*/
/*  *     It is used where a visual label is not needed, such as a table of*/
/*  *     checkboxes where the row and column provide the context. The tooltip will*/
/*  *     include the title and required marker.*/
/*  * - description: (optional) A list of description properties containing:*/
/*  *    - content: A description of the form element, may not be set.*/
/*  *    - attributes: (optional) A list of HTML attributes to apply to the*/
/*  *      description content wrapper. Will only be set when description is set.*/
/*  * - description_display: Description display setting. It can have these values:*/
/*  *   - before: The description is output before the element.*/
/*  *   - after: The description is output after the element. This is the default*/
/*  *     value.*/
/*  *   - invisible: The description is output after the element, hidden visually*/
/*  *     but available to screen readers.*/
/*  * - disabled: True if the element is disabled.*/
/*  * - title_display: Title display setting.*/
/*  **/
/*  * @ingroup templates*/
/*  **/
/*  * @see template_preprocess_form_element()*/
/*  *//* */
/* #}*/
/* {%*/
/*   set classes = [*/
/*     'form-item',*/
/*     'js-form-item',*/
/*     'form-type-' ~ type|clean_class,*/
/*     'js-form-type-' ~ type|clean_class,*/
/*     'form-item-' ~ name|clean_class,*/
/*     'js-form-item-' ~ name|clean_class,*/
/*     title_display not in ['after', 'before'] ? 'form-no-label',*/
/*     disabled == 'disabled' ? 'form-disabled',*/
/*     is_form_group ? 'form-group',*/
/*     is_radio ? 'radio',*/
/*     is_checkbox ? 'checkbox',*/
/*     is_autocomplete ? 'form-autocomplete',*/
/*     errors ? 'error has-error'*/
/*   ]*/
/* %}{%*/
/*   set description_classes = [*/
/*     'description',*/
/*     'help-block',*/
/*     description_display == 'invisible' ? 'visually-hidden',*/
/*   ]*/
/* %}*/
/* <div{{ attributes.addClass(classes) }}>*/
/*   {% if label_display in ['before', 'invisible'] %}*/
/*     {{ label }}*/
/*   {% endif %}*/
/* */
/*   {% if description_display == 'before' and description.content %}*/
/*     <div{{ description.attributes }}>*/
/*       {{ description.content }}*/
/*     </div>*/
/*   {% endif %}*/
/* */
/*   {{ children }}*/
/* */
/*   {% if label_display == 'after' %}*/
/*     {{ label }}*/
/*   {% endif %}*/
/* */
/*   {% if description_display in ['after', 'invisible'] and description.content %}*/
/*     <div{{ description.attributes.addClass(description_classes) }}>*/
/*       {{ description.content }}*/
/*     </div>*/
/*   {% endif %}*/
/* </div>*/
/* */
