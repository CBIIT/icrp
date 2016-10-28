<?php

/* {# inline_template_start #}{{ description }}{% if not supported %}<div><small>{% trans %}<strong>Not available</strong>. You may need to install external dependencies for use this plugin.{% endtrans %}</small></div>{% endif %} */
class __TwigTemplate_739c2eca56b0c7f1f8c46c1523248820751da02a2c24ad36e89ef8e17d8bfb3b extends Twig_Template
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
        $tags = array("if" => 1, "trans" => 1);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if', 'trans'),
                array(),
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

        // line 1
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["description"]) ? $context["description"] : null), "html", null, true));
        if ( !(isset($context["supported"]) ? $context["supported"] : null)) {
            echo "<div><small>";
            echo t("<strong>Not available</strong>. You may need to install external dependencies for use this plugin.", array());
            echo "</small></div>";
        }
    }

    public function getTemplateName()
    {
        return "{# inline_template_start #}{{ description }}{% if not supported %}<div><small>{% trans %}<strong>Not available</strong>. You may need to install external dependencies for use this plugin.{% endtrans %}</small></div>{% endif %}";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  43 => 1,);
    }
}
/* {# inline_template_start #}{{ description }}{% if not supported %}<div><small>{% trans %}<strong>Not available</strong>. You may need to install external dependencies for use this plugin.{% endtrans %}</small></div>{% endif %}*/
