import { EnvironmentProviders, makeEnvironmentProviders } from '@angular/core';
import { environment } from '../../../environments/environment';
import { API_BASE_URL } from './config';

export function provideAppConfig(): EnvironmentProviders {
  return makeEnvironmentProviders([
    {
      provide: API_BASE_URL,
      useValue: resolveApiBaseUrl(environment.apiBaseUrl),
    },
  ]);
}

export function resolveApiBaseUrl(value: string): string {
  if (value.trim().length === 0) {
    throw new Error(
      'apiBaseUrl is not defined. Add it to the environment file this build configuration replaces in.',
    );
  }

  return value;
}
