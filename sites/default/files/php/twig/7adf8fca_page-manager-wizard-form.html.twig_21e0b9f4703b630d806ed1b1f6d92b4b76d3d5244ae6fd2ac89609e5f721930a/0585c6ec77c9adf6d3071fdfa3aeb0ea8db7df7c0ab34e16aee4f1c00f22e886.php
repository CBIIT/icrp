<?php

/* modules/page_manager/page_manager_ui/templates/page-manager-wizard-form.html.twig */
class __TwigTemplate_fdf19d41e07a412120289b0cb820e747cb7fb8e4dc467b41a75d8fa361e7b537 extends Twig_Template
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
        $tags = array();
        $filters = array("without" => 24);
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array(),
                array('without'),
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

        // line 15
        echo "<div class=\"page-manager-wizard\">
  <div class=\"page-manager-wizard-actions\">
    ";
        // line 17
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["form"]) ? $context["form"] : null), "wizard_actions", array()), "html", null, true));
        echo "
  </div>
  <div class=\"page-manager-wizard-main clearfix\">
    <div class=\"page-manager-wizard-tree\">
      ";
        // line 21
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["form"]) ? $context["form"] : null), "wizard_tree", array()), "html", null, true));
        echo "
    </div>
    <div class=\"page-manager-wizard-form\">
      ";
        // line 24
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, twig_without((isset($context["form"]) ? $context["form"] : null), "wizard_actions", "wizard_tree", "actions"), "html", null, true));
        echo "
    </div>
  </div>

  <div class=\"page-manager-wizard-form-actions\">
    ";
        // line 29
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, $this->getAttribute((isset($context["form"]) ? $context["form"] : null), "actions", array()), "html", null, true));
        echo "
  </div>
</div>
";
    }

    public function getTemplateName()
    {
        return "modules/page_manager/page_manager_ui/templates/page-manager-wizard-form.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  68 => 29,  60 => 24,  54 => 21,  47 => 17,  43 => 15,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for a 'form' element.*/
/*  **/
/*  * Available variables*/
/*  * - attributes: A list of HTML attributes for the wrapper element.*/
/*  * - children: The child elements of the form.*/
/*  **/
/*  * @see template_preprocess_form()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* <div class="page-manager-wizard">*/
/*   <div class="page-manager-wizard-actions">*/
/*     {{ form.wizard_actions }}*/
/*   </div>*/
/*   <div class="page-manager-wizard-main clearfix">*/
/*     <div class="page-manager-wizard-tree">*/
/*       {{ form.wizard_tree }}*/
/*     </div>*/
/*     <div class="page-manager-wizard-form">*/
/*       {{ form|without('wizard_actions', 'wizard_tree', 'actions') }}*/
/*     </div>*/
/*   </div>*/
/* */
/*   <div class="page-manager-wizard-form-actions">*/
/*     {{ form.actions }}*/
/*   </div>*/
/* </div>*/
/* */
