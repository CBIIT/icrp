<?php

/* core/modules/user/templates/user.html.twig */
class __TwigTemplate_fb8d12b7c1ba3c2cb72f333e425e734b597121eba66e88c09f9d74b698e04749 extends Twig_Template
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
        $__internal_a5b1e995c771185728ca31ce51a299d0a33494584047b2dac203374290093689 = $this->env->getExtension("native_profiler");
        $__internal_a5b1e995c771185728ca31ce51a299d0a33494584047b2dac203374290093689->enter($__internal_a5b1e995c771185728ca31ce51a299d0a33494584047b2dac203374290093689_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/user/templates/user.html.twig"));

        $tags = array("if" => 22);
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('sandbox')->checkSecurity(
                array('if'),
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

        // line 21
        echo "<article";
        echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["attributes"]) ? $context["attributes"] : null), "html", null, true));
        echo ">
  ";
        // line 22
        if ((isset($context["content"]) ? $context["content"] : null)) {
            // line 23
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["content"]) ? $context["content"] : null), "html", null, true));
        }
        // line 25
        echo "</article>
";
        
        $__internal_a5b1e995c771185728ca31ce51a299d0a33494584047b2dac203374290093689->leave($__internal_a5b1e995c771185728ca31ce51a299d0a33494584047b2dac203374290093689_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/user/templates/user.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  56 => 25,  53 => 23,  51 => 22,  46 => 21,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation to present all user data.*/
/*  **/
/*  * This template is used when viewing a registered user's page,*/
/*  * e.g., example.com/user/123. 123 being the user's ID.*/
/*  **/
/*  * Available variables:*/
/*  * - content: A list of content items. Use 'content' to print all content, or*/
/*  *   print a subset such as 'content.field_example'. Fields attached to a user*/
/*  *   such as 'user_picture' are available as 'content.user_picture'.*/
/*  * - attributes: HTML attributes for the container element.*/
/*  * - user: A Drupal User entity.*/
/*  **/
/*  * @see template_preprocess_user()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* <article{{ attributes }}>*/
/*   {% if content %}*/
/*     {{- content -}}*/
/*   {% endif %}*/
/* </article>*/
/* */
