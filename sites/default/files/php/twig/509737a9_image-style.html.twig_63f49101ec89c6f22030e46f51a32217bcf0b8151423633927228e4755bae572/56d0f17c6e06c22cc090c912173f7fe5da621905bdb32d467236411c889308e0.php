<?php

/* core/modules/image/templates/image-style.html.twig */
class __TwigTemplate_a981e3efaed70d45f19e969288b044e4be66d7ed5ba1955eb9e8e3ef6ba977a4 extends Twig_Template
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
        $filters = array();
        $functions = array();

        try {
            $this->env->getExtension('Twig_Extension_Sandbox')->checkSecurity(
                array(),
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

        // line 20
        echo $this->env->getExtension('Twig_Extension_Sandbox')->ensureToStringAllowed($this->env->getExtension('Drupal\Core\Template\TwigExtension')->escapeFilter($this->env, ($context["image"] ?? null), "html", null, true));
        echo "
";
    }

    public function getTemplateName()
    {
        return "core/modules/image/templates/image-style.html.twig";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  43 => 20,);
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
 * Default theme implementation for an image using a specific image style.
 *
 * Available variables:
 * - attributes: HTML attributes for the image, including the following:
 *   - src: Full URL or relative path to the image file.
 *   - class: One or more classes to be applied to the image.
 *   - width: The width of the image (if known).
 *   - height: The height of the image (if known).
 *   - title: The title of the image.
 *   - alt: The alternative text for the image.
 *
 * @see template_preprocess_image_style()
 *
 * @ingroup themeable
 */
#}
{{ image }}
", "core/modules/image/templates/image-style.html.twig", "/github/drupal8.dev/core/modules/image/templates/image-style.html.twig");
    }
}
