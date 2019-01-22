<?php

namespace Drupal\rhd_common\Routing;

use Drupal\Core\Routing\RouteSubscriberBase;
use Symfony\Component\Routing\RouteCollection;

/**
 * Class DisableAuthRoutesRouteSubscriber.
 *
 * Listens to the dynamic route events.
 */
class DisableAuthRoutesRouteSubscriber extends RouteSubscriberBase {

  /**
   * {@inheritdoc}
   */
  protected function alterRoutes(RouteCollection $collection) {
    // An array of routes to disallow.
    $disallow_routes = [
      'user.register',
      'user.pass',
    ];

    // Iterate through the disallowed routes and set _access to FALSE.
    foreach ($disallow_routes as $disallow_route) {
      if ($route = $collection->get($disallow_route)) {
        $route->setRequirement('_access', 'FALSE');
      }
    }
  }
}
