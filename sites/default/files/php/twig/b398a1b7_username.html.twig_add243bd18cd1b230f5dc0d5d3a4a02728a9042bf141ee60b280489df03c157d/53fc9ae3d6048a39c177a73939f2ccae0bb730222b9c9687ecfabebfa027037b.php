<?php

/* core/modules/user/templates/username.html.twig */
class __TwigTemplate_e5bdb8e152af6993a4ae5e0c22586085223b2f9c3a52c562987d8a9f53502946 extends Twig_Template
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
        $__internal_ee2e8101bc2fe3e695e5a59478b6f12f0b893cb653119d74dba8e30c703f41e1 = $this->env->getExtension("native_profiler");
        $__internal_ee2e8101bc2fe3e695e5a59478b6f12f0b893cb653119d74dba8e30c703f41e1->enter($__internal_ee2e8101bc2fe3e695e5a59478b6f12f0b893cb653119d74dba8e30c703f41e1_prof = new Twig_Profiler_Profile($this->getTemplateName(), "template", "core/modules/user/templates/username.html.twig"));

        $tags = array("if" => 21);
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
        if ((isset($context["link_path"]) ? $context["link_path"] : null)) {
            // line 22
            echo "<a";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["attributes"]) ? $context["attributes"] : null), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["name"]) ? $context["name"] : null), "html", null, true));
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["extra"]) ? $context["extra"] : null), "html", null, true));
            echo "</a>";
        } else {
            // line 24
            echo "<span";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["attributes"]) ? $context["attributes"] : null), "html", null, true));
            echo ">";
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["name"]) ? $context["name"] : null), "html", null, true));
            echo $this->env->getExtension('sandbox')->ensureToStringAllowed($this->env->getExtension('drupal_core')->escapeFilter($this->env, (isset($context["extra"]) ? $context["extra"] : null), "html", null, true));
            echo "</span>";
        }
        
        $__internal_ee2e8101bc2fe3e695e5a59478b6f12f0b893cb653119d74dba8e30c703f41e1->leave($__internal_ee2e8101bc2fe3e695e5a59478b6f12f0b893cb653119d74dba8e30c703f41e1_prof);

    }

    public function getTemplateName()
    {
        return "core/modules/user/templates/username.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  56 => 24,  48 => 22,  46 => 21,);
    }
}
/* {#*/
/* /***/
/*  * @file*/
/*  * Default theme implementation for displaying a username.*/
/*  **/
/*  * Available variables:*/
/*  * - account: The full account information for the user.*/
/*  * - name: The user's name, sanitized.*/
/*  * - extra: Additional text to append to the user's name, sanitized.*/
/*  * - link_path: The path or URL of the user's profile page, home page,*/
/*  *   or other desired page to link to for more information about the user.*/
/*  * - link_options: Options to set on the \Drupal\Core\Url object if linking the*/
/*  *   user's name to the user's page.*/
/*  * - attributes: HTML attributes for the containing element.*/
/*  **/
/*  * @see template_preprocess_username()*/
/*  **/
/*  * @ingroup themeable*/
/*  *//* */
/* #}*/
/* {% if link_path -%}*/
/*   <a{{ attributes }}>{{ name }}{{ extra }}</a>*/
/* {%- else -%}*/
/*   <span{{ attributes }}>{{ name }}{{ extra }}</span>*/
/* {%- endif -%}*/
/* */
