import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { ApplicationConfig, provideBrowserGlobalErrorListeners } from '@angular/core';
import { provideRouter, withComponentInputBinding } from '@angular/router';
import { routes } from './app.routes';
import { provideAppConfig } from './core/config/app-config.provider';
import { FeedbackService } from './core/feedback/feedback.service';
import { ToastFeedbackService } from './core/feedback/toast-feedback.service';
import { errorInterceptor } from './core/http/error.interceptor';
import { ConsoleObservabilityService } from './core/observability/console-observability.service';
import { ObservabilityService } from './core/observability/observability.service';

export const appConfig: ApplicationConfig = {
  providers: [
    provideBrowserGlobalErrorListeners(),
    // Component inputs bound from route params: EventDetail takes `id` that way.
    provideRouter(routes, withComponentInputBinding()),
    provideAppConfig(),
    provideHttpClient(withInterceptors([errorInterceptor])),
    { provide: FeedbackService, useExisting: ToastFeedbackService },
    { provide: ObservabilityService, useExisting: ConsoleObservabilityService },
  ],
};
