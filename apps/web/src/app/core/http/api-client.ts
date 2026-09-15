import { HttpClient, HttpParams } from '@angular/common/http';
import { Service, inject } from '@angular/core';
import { Observable, catchError, map, throwError } from 'rxjs';
import { parsingError } from '../error/app-error';
import { toAppError } from '../error/error-mapper';
import { API_BASE_URL } from '@core/config/config';

/** Query parameter values `undefined` entries are dropped, not sent as `"undefined"`. */
export type QueryParams = Readonly<Record<string, string | number | boolean | undefined>>;

@Service()
export class ApiClient {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = inject(API_BASE_URL);

  get<T>(path: string, options: { parser: (data: unknown) => T; params?: QueryParams }) {
    return this.send(
      this.http.get<unknown>(this.url(path), { params: this.toHttpParams(options.params) }),
      options.parser,
    );
  }

  post<T>(
    path: string,
    options: { parser: (data: unknown) => T; body?: unknown; params?: QueryParams },
  ) {
    return this.send(
      this.http.post<unknown>(this.url(path), options.body ?? null, {
        params: this.toHttpParams(options.params),
      }),
      options.parser,
    );
  }

  put<T>(
    path: string,
    options: { parser: (data: unknown) => T; body?: unknown; params?: QueryParams },
  ) {
    return this.send(
      this.http.put<unknown>(this.url(path), options.body ?? null, {
        params: this.toHttpParams(options.params),
      }),
      options.parser,
    );
  }

  delete<T>(path: string, options: { parser: (data: unknown) => T }) {
    return this.send(this.http.delete<unknown>(this.url(path)), options.parser);
  }

  private send<T>(response$: Observable<unknown>, parser: (data: unknown) => T): Observable<T> {
    return response$.pipe(
      map((data) => this.parseOrThrow(parser, data)),
      catchError((error: unknown) => throwError(() => toAppError(error))),
    );
  }

  private parseOrThrow<T>(parser: (data: unknown) => T, data: unknown): T {
    try {
      return parser(data);
    } catch (error) {
      throw parsingError({ message: 'Failed to parse server response.', cause: error });
    }
  }

  private url(path: string): string {
    return `${this.baseUrl}${path}`;
  }

  private toHttpParams(params: QueryParams | undefined): HttpParams | undefined {
    if (!params) {
      return undefined;
    }

    let httpParams = new HttpParams();
    for (const [key, value] of Object.entries(params)) {
      if (value !== undefined) {
        httpParams = httpParams.set(key, String(value));
      }
    }
    return httpParams;
  }
}
